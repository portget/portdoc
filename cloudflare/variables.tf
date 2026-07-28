variable "cloudflare_api_token" {
  description = "Cloudflare API Token (Zone:Edit, WAF:Edit 권한 필요)"
  type        = string
  sensitive   = true
}

variable "zone_id" {
  description = "portdic.com Cloudflare Zone ID (대시보드 > 도메인 > 우측 하단)"
  type        = string
}
