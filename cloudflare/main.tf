terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ─────────────────────────────────────────────────────────────────────────────
# WAF Custom Rules
# 무료 플랜: 최대 5개 규칙
# ─────────────────────────────────────────────────────────────────────────────
resource "cloudflare_ruleset" "waf_custom" {
  zone_id     = var.zone_id
  name        = "PortDIC WAF Custom Rules"
  description = "Block AI crawlers, scrapers, and bad bots"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  # Rule 1: AI 학습 데이터 수집 봇 완전 차단
  rules {
    action      = "block"
    description = "Block AI training crawlers"
    enabled     = true
    expression  = <<-EOT
      (http.user_agent contains "GPTBot") or
      (http.user_agent contains "ChatGPT-User") or
      (http.user_agent contains "OAI-SearchBot") or
      (http.user_agent contains "ClaudeBot") or
      (http.user_agent contains "anthropic-ai") or
      (http.user_agent contains "Google-Extended") or
      (http.user_agent contains "CCBot") or
      (http.user_agent contains "PerplexityBot") or
      (http.user_agent contains "Bytespider") or
      (http.user_agent contains "Amazonbot") or
      (http.user_agent contains "FacebookBot") or
      (http.user_agent contains "Applebot-Extended")
    EOT
  }

  # Rule 2: 공격적 SEO 스크래퍼 차단
  rules {
    action      = "block"
    description = "Block aggressive SEO scrapers"
    enabled     = true
    expression  = <<-EOT
      (http.user_agent contains "AhrefsBot") or
      (http.user_agent contains "SemrushBot") or
      (http.user_agent contains "MJ12bot") or
      (http.user_agent contains "DotBot") or
      (http.user_agent contains "BLEXBot") or
      (http.user_agent contains "DataForSeoBot") or
      (http.user_agent contains "PetalBot")
    EOT
  }

  # Rule 3: 비어있는 User-Agent → JS Challenge
  # 정상 브라우저는 항상 User-Agent를 보낸다.
  rules {
    action      = "js_challenge"
    description = "Challenge empty or missing User-Agent"
    enabled     = true
    expression  = "(http.user_agent eq \"\")"
  }

  # Rule 4: /file/ 핫링킹 차단
  # portdic.com에서 직접 접근하는 경우만 허용.
  # Referer가 없는 경우(직접 URL 입력)는 허용한다.
  rules {
    action      = "block"
    description = "Block hotlinking of downloadable files"
    enabled     = true
    expression  = <<-EOT
      (http.request.uri.path contains "/file/") and
      (http.referer ne "") and
      not (http.referer contains "portdic.com")
    EOT
  }

  # Rule 5: 위협 점수 높은 IP → Managed Challenge (CAPTCHA)
  # threat_score: 0(안전) ~ 100(위험). 50 이상은 알려진 악성 IP.
  rules {
    action      = "managed_challenge"
    description = "Challenge high threat score IPs"
    enabled     = true
    expression  = "(cf.threat_score gt 50)"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Rate Limiting Rules
# 무료 플랜: 1개 규칙, 분당 요청 수 제한
# Pro 이상: 복수 규칙, 세분화된 경로별 제한 가능
# ─────────────────────────────────────────────────────────────────────────────
resource "cloudflare_ruleset" "rate_limiting" {
  zone_id     = var.zone_id
  name        = "PortDIC Rate Limiting"
  description = "Throttle IPs that exceed normal browsing rate"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules {
    action      = "block"
    description = "Block IPs exceeding 120 requests per minute"
    enabled     = true
    expression  = "true"

    action_parameters {
      response {
        status_code  = 429
        content_type = "text/plain"
        content      = "429 Too Many Requests - Please slow down."
      }
    }

    ratelimit {
      # 제한 기준: 요청자 IP
      characteristics     = ["ip.src"]
      # 측정 윈도우: 60초
      period              = 60
      # 임계값: 분당 120 요청 초과 시 차단
      requests_per_period = 120
      # 차단 지속 시간: 10분
      mitigation_timeout  = 600
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Zone Security Settings
# ─────────────────────────────────────────────────────────────────────────────
resource "cloudflare_zone_settings_override" "portdic" {
  zone_id = var.zone_id

  settings {
    # 보안 레벨: 위협 점수 14 이상인 방문자에게 Challenge 표시
    # off | essentially_off | low | medium | high | under_attack
    security_level = "medium"

    # HTTPS 강제 리디렉션
    always_use_https = "on"

    # 최소 TLS 버전 (1.0/1.1은 취약)
    min_tls_version = "1.2"

    # SSL 모드: Full Strict (Netlify는 유효 인증서 보유)
    ssl = "full"

    # HSTS (HTTP Strict Transport Security)
    security_header {
      enabled            = true
      include_subdomains = true
      max_age            = 31536000  # 1년
      preload            = true
      nosniff            = true
    }

    # Brotli 압축 활성화
    brotli = "on"

    # Email 주소 난독화 (스팸봇 수집 방지)
    email_obfuscation = "on"

    # 서버 측 Hotlink 방지
    hotlink_protection = "on"

    # Bot Fight Mode: 알려진 봇 자동 차단 (무료)
    # Cloudflare 대시보드 Security > Bots 에서도 활성화 가능
    browser_check = "on"
  }
}
