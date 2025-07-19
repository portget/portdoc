# SECS Message Format Specification

## Table of Contents
1. [Overview](#overview) 
2. [SECS-II Data Format](#secs-ii-data-format)
3. [Stream Definitions](#stream-definitions)
4. [Message Categories](#message-categories)
5. [Common Message Examples](#common-message-examples)
6. [Implementation Guidelines](#implementation-guidelines)

## Quick link
| Stream | Function |
|---|---|
| S1 | [F1](#s1f1---are-you-there-request) [F2](#s1f2---are-you-there-response) [F3](#s1f3r---selected-equipment-status-request) [F4](#s1f4---selected-equipment-status-data) [F5](#s1f5r---formatted-status-request) [F6](#s1f6---formatted-status-data) [F7](#s1f7---fixed-form-request) [F8](#s1f8---fixed-form-data) [F9](#s1f9r---material-transfer-status-request) [F10](#s1f10---material-transfer-status-data) [F11](#s1f11r---status-variable-namelist-request) [F12](#s1f12---status-variable-namelist-reply) [F13](#s1f13r---establish-communications-request) [F14](#s1f14---establish-communications-request-acknowledge) [F15](#s1f15r---request-offline) [F16](#s1f16---offline-acknowledge) [F17](#s1f17r---request-online) [F18](#s1f18---online-acknowledge) [F19](#s1f19r---get-attribute) [F20](#s1f20---attribute-data) [F21](#s1f21r---data-variable-namelist-request) [F22](#s1f22---data-variable-namelist-reply) [F23](#s1f23r---collection-event-namelist-request) [F24](#s1f24---collection-event-namelist-reply) |
| S2 | [F1](#s2f1---equipment-status-request) [F2](#s2f2---equipment-status-response) [F3](#s2f3---status-variable-value-request) [F4](#s2f4---status-variable-value-response) [F5](#s2f5---send-equipment-status) [F6](#s2f6---send-equipment-status-acknowledge) [F7](#s2f7---load-port-status-request) [F8](#s2f8---load-port-status-response) [F9](#s2f9---equipment-status-multi-block-inquire) [F10](#s2f10---equipment-status-multi-block-grant) [F11](#s2f11---equipment-status-multi-block) [F12](#s2f12---equipment-status-multi-block-acknowledge) [F13](#s2f13---equipment-constant-request) [F14](#s2f14---equipment-constant-response) [F15](#s2f15---new-equipment-constant-send) [F16](#s2f16---new-equipment-constant-acknowledge) [F17](#s2f17---date-and-time-request) [F18](#s2f18---date-and-time-response) [F19](#s2f19---recipe-body-request) [F20](#s2f20---recipe-body-response) [F21](#s2f21---recipe-body-send) [F22](#s2f22---recipe-body-acknowledge) [F23](#s2f23---trace-initialize-send) [F24](#s2f24---trace-initialize-acknowledge) [F25](#s2f25---loopback-diagnostic-request) [F26](#s2f26---loopback-diagnostic-response) [F27](#s2f27---initiate-processing-request) [F28](#s2f28---initiate-processing-acknowledge) [F29](#s2f29---equipment-constant-namelist-request) [F30](#s2f30---equipment-constant-namelist-response) [F31](#s2f31---date-and-time-set-request) [F32](#s2f32---date-and-time-set-response) [F33](#s2f33---define-report) [F34](#s2f34---define-report-acknowledge) [F35](#s2f35---link-event-report) [F36](#s2f36---link-event-report-acknowledge) [F37](#s2f37---enabledisable-event-report) [F38](#s2f38---enabledisable-event-report-acknowledge) [F39](#s2f39---status-variable-namelist-request) [F40](#s2f40---status-variable-namelist-response) [F41](#s2f41---host-command-send) [F42](#s2f42---host-command-acknowledge) [F43](#s2f43---reset-spooling-streams-and-functions) [F44](#s2f44---reset-spooling-acknowledge) [F45](#s2f45---define-variable-limit-attributes) [F46](#s2f46---define-variable-limit-attributes-acknowledge) [F47](#s2f47---variable-limit-attribute-request) [F48](#s2f48---variable-limit-attribute-response) [F49](#s2f49---enhanced-remote-command) [F50](#s2f50---enhanced-remote-command-acknowledge) [F51](#s2f51---request-report-identifiers) [F52](#s2f52---return-report-identifiers) [F53](#s2f53---request-report-definitions) [F54](#s2f54---return-report-definitions) [F55](#s2f55---request-event-report-links) [F56](#s2f56---return-event-report-links) [F57](#s2f57---request-enabled-events) [F58](#s2f58---return-enabled-events) [F59](#s2f59---request-spool-streams-and-functions) [F60](#s2f60---return-spool-streams-and-functions) [F61](#s2f61---request-trace-identifiers) [F62](#s2f62---return-trace-identifiers) [F63](#s2f63---request-trace-definitions) [F64](#s2f64---return-trace-definitions) |
| S3 | [F1](#s3f1---material-status-request) [F2](#s3f2---material-status-data) [F3](#s3f3---time-to-completion-data) [F4](#s3f4---time-to-completion-data) [F5](#s3f5---material-found-send) [F6](#s3f6---material-found-acknowledge) [F7](#s3f7---material-lost-send) [F8](#s3f8---material-lost-ack) [F9](#s3f9---matl-id-equate-send) [F10](#s3f10---port-status-acknowledge) [F11](#s3f11---matl-id-request) [F12](#s3f12---matl-id-request-ack) [F13](#s3f13---matl-id-send) [F14](#s3f14---matl-id-ack) [F15](#s3f15---matls-multi-block-inquire) [F16](#s3f16---matls-multi-block-grant) [F17](#s3f17---carrier-action-request-extended) [F18](#s3f18---carrier-action-response-extended) [F19](#s3f19---port-action-request) [F20](#s3f20---cancel-all-carrier-out-ack) [F21](#s3f21---port-group-defn) [F22](#s3f22---port-group-defn-ack) [F23](#s3f23---port-group-action-req) [F24](#s3f24---port-group-action-ack) [F25](#s3f25---port-action-req) [F26](#s3f26---port-action-ack) [F27](#s3f27---change-access) [F28](#s3f28---change-access-ack) [F29](#s3f29---carrier-tag-read-req) [F30](#s3f30---carrier-tag-read-data) [F31](#s3f31---carrier-tag-write-data) [F32](#s3f32---carrier-tag-write-ack) [F33](#s3f33---cancel-all-pod-out-req) [F34](#s3f34---cancel-all-pod-out-ack) [F35](#s3f35---reticle-transfer-job-req) [F36](#s3f36---reticle-transfer-job-ack) |
| S4 | [F1](#s4f1---ready-to-send-materials) [F2](#s4f2---ready-to-send-acknowledge) [F3](#s4f3---send-material) [F5](#s4f5---handshake-complete) [F7](#s4f7---not-ready-to-send) [F9](#s4f9---stuck-in-sender) [F11](#s4f11---stuck-in-receiver) [F13](#s4f13---send-incomplete-timeout) [F15](#s4f15---material-received) [F17](#s4f17---request-to-receive) [F18](#s4f18---request-to-receive-acknowledge) [F19](#s4f19---transfer-job-create) [F20](#s4f20---transfer-job-acknowledge) [F21](#s4f21---transfer-job-command) |
| S5 | [F1](#s5f1---alarm-report-send) [F2](#s5f2---alarm-report-acknowledge) [F3](#s5f3---enabledisable-alarm-send) [F4](#s5f4---enabledisable-alarm-acknowledge) [F5](#s5f5---list-alarms-request) [F6](#s5f6---list-alarms-response) [F7](#s5f7---list-enabled-alarm-request) [F8](#s5f8---list-enabled-alarm-response) [F9](#s5f9---alarm-summary-request) [F10](#s5f10---alarm-summary-response) [F11](#s5f11---alarm-summary-send) [F12](#s5f12---alarm-summary-acknowledge) [F13](#s5f13---alarm-history-request) [F14](#s5f14---alarm-history-response) [F15](#s5f15---alarm-history-send) [F16](#s5f16---alarm-history-acknowledge) [F17](#s5f17---alarm-acknowledge-request) [F18](#s5f18---alarm-acknowledge-response) [F19](#s5f19---alarm-acknowledge-send) [F20](#s5f20---alarm-acknowledge-acknowledge) [F21](#s5f21---alarm-clear-request) [F22](#s5f22---alarm-clear-response) [F23](#s5f23---alarm-clear-send) [F24](#s5f24---alarm-clear-acknowledge) [F25](#s5f25---alarm-test-request) [F26](#s5f26---alarm-test-response) [F27](#s5f27---alarm-test-send) [F28](#s5f28---alarm-test-acknowledge) [F29](#s5f29---alarm-reset-request) [F30](#s5f30---alarm-reset-response) |
| S6 | [F1](#s6f1---trace-data-send) [F2](#s6f2---trace-data-acknowledge) [F3](#s6f3---discrete-variable-data-send) [F4](#s6f4---discrete-variable-data-acknowledge) [F5](#s6f5---multi-block-data-send-inquire) [F6](#s6f6---multi-block-grant) [F7](#s6f7---data-transfer-request) [F8](#s6f8---data-transfer-data) [F9](#s6f9---formatted-variable-send) [F10](#s6f10---formatted-variable-acknowledge) [F11](#s6f11---event-report-send) [F12](#s6f12---event-report-acknowledge) [F13](#s6f13---annotated-event-report-send) [F14](#s6f14---annotated-event-report-acknowledge) [F15](#s6f15---event-report-request) [F16](#s6f16---event-report-data) [F17](#s6f17---annotated-event-report-request) [F18](#s6f18---annotated-event-report-data) [F19](#s6f19---individual-report-request) [F20](#s6f20---individual-report-data) [F21](#s6f21---annotated-individual-report-request) [F22](#s6f22---annotated-individual-report-data) [F23](#s6f23---request-or-purge-spooled-data) [F24](#s6f24---request-or-purge-spooled-data-acknowledge) [F25](#s6f25---notification-report-send) [F26](#s6f26---notification-report-acknowledge) [F27](#s6f27---trace-report-send) [F28](#s6f28---trace-report-acknowledge) [F29](#s6f29---trace-report-request) [F30](#s6f30---trace-report-data) |
| S7 | [F1](#s7f1---process-program-load-inquire) [F2](#s7f2---process-program-load-grant) [F3](#s7f3---process-program-send) [F4](#s7f4---process-program-send-acknowledge) [F5](#s7f5---process-program-request) [F6](#s7f6---process-program-data) [F7](#s7f7---process-program-id-request) [F8](#s7f8---process-program-id-data) [F9](#s7f9---material-process-matrix-request) [F10](#s7f10---material-process-matrix-data) [F11](#s7f11---material-process-matrix-update-send) [F12](#s7f12---material-process-matrix-update-acknowledge) [F13](#s7f13---material-process-matrix-delete-entry-send) [F14](#s7f14---delete-material-process-matrix-entry-acknowledge) [F15](#s7f15---matrix-mode-select-send) [F16](#s7f16---matrix-mode-select-acknowledge) [F17](#s7f17---delete-process-program-send) [F18](#s7f18---delete-process-program-acknowledge) [F19](#s7f19---current-process-program-directory-request) [F20](#s7f20---current-process-program-data) [F21](#s7f21---process-capabilities-request) [F22](#s7f22---process-capabilities-data) [F23](#s7f23---formatted-process-program-send) [F24](#s7f24---formatted-process-program-acknowledge) [F25](#s7f25---formatted-process-program-request) [F26](#s7f26---formatted-process-program-data) [F27](#s7f27---process-program-verification-send) [F28](#s7f28---process-program-verification-acknowledge) [F29](#s7f29---process-program-verification-inquire) [F30](#s7f30---process-program-verification-grant) [F31](#s7f31---verification-request-send) [F32](#s7f32---verification-request-acknowledge) [F33](#s7f33---process-program-available-request) [F34](#s7f34---process-program-availability-data) [F35](#s7f35---process-program-for-mid-request) [F36](#s7f36---process-program-for-mid-data) [F37](#s7f37---large-process-program-send) [F38](#s7f38---large-process-program-send-acknowledge) [F39](#s7f39---large-formatted-process-program-send) [F40](#s7f40---large-formatted-process-program-acknowledge) [F41](#s7f41---large-process-program-request) [F42](#s7f42---large-process-program-request-acknowledge) [F43](#s7f43---large-formatted-process-program-request) [F44](#s7f44---large-formatted-process-program-request-acknowledge) |
| S8 | [F1](#s8f1---boot-program-request) [F2](#s8f2---boot-program-data) [F3](#s8f3---executive-program-request) [F4](#s8f4---executive-program-data) |
| S9 | [F1](#s9f1---unrecognized-device-id) [F2](#s9f2---unrecognized-device-id-acknowledge) [F3](#s9f3---unrecognized-stream-type) [F4](#s9f4---unrecognized-stream-type-acknowledge) [F5](#s9f5---unrecognized-function-type) [F6](#s9f6---unrecognized-function-type-acknowledge) [F7](#s9f7---illegal-data) [F8](#s9f8---illegal-data-acknowledge) [F9](#s9f9---transaction-timer-timeout) [F10](#s9f10---transaction-timer-timeout-acknowledge) [F11](#s9f11---data-too-long) [F12](#s9f12---data-too-long-acknowledge) [F13](#s9f13---conversation-timeout) [F14](#s9f14---conversation-timeout-acknowledge) [F15](#s9f15---invalid-command) [F16](#s9f16---invalid-command-acknowledge) [F17](#s9f17---invalid-parameter) [F18](#s9f18---invalid-parameter-acknowledge) [F19](#s9f19---invalid-data) [F20](#s9f20---invalid-data-acknowledge) [F21](#s9f21---invalid-format) [F22](#s9f22---invalid-format-acknowledge) [F23](#s9f23---invalid-sequence) [F24](#s9f24---invalid-sequence-acknowledge) [F25](#s9f25---invalid-timestamp) [F26](#s9f26---invalid-timestamp-acknowledge) [F27](#s9f27---invalid-status) [F28](#s9f28---invalid-status-acknowledge) [F29](#s9f29---invalid-version) [F30](#s9f30---invalid-version-acknowledge) |
| S10 | [F1](#s10f1---terminal-request) [F2](#s10f2---terminal-response) [F3](#s10f3---terminal-display-single) [F5](#s10f5---terminal-display-multi-block) [F7](#s10f7---multi-block-not-allowed) [F9](#s10f9---broadcast-display-request) [F10](#s10f10---broadcast-display-acknowledge) |
| S11 | [F1](#s11f1---host-command-request) [F2](#s11f2---host-command-response) [F3](#s11f3---host-command-send) [F4](#s11f4---host-command-acknowledge) [F5](#s11f5---host-command-list-request) [F6](#s11f6---host-command-list-response) [F7](#s11f7---host-command-list-send) [F8](#s11f8---host-command-list-acknowledge) [F9](#s11f9---host-command-upload-request) [F10](#s11f10---host-command-upload-response) [F11](#s11f11---host-command-upload-send) [F12](#s11f12---host-command-upload-acknowledge) [F13](#s11f13---host-command-download-request) [F14](#s11f14---host-command-download-response) [F15](#s11f15---host-command-download-send) [F16](#s11f16---host-command-download-acknowledge) [F17](#s11f17---host-command-validate-request) [F18](#s11f18---host-command-validate-response) [F19](#s11f19---host-command-validate-send) [F20](#s11f20---host-command-validate-acknowledge) [F21](#s11f21---host-command-execute-request) [F22](#s11f22---host-command-execute-response) [F23](#s11f23---host-command-execute-send) [F24](#s11f24---host-command-execute-acknowledge) [F25](#s11f25---host-command-stop-request) [F26](#s11f26---host-command-stop-response) [F27](#s11f27---host-command-stop-send) [F28](#s11f28---host-command-stop-acknowledge) [F29](#s11f29---host-command-pause-request) [F30](#s11f30---host-command-pause-response) |
| S12 | [F1](#s12f1---map-setup-data-send) [F2](#s12f2---map-setup-data-acknowledge) [F3](#s12f3---map-setup-data-request) [F4](#s12f4---map-setup-data-response) [F5](#s12f5---map-transmit-inquire) [F6](#s12f6---map-transmit-grant) [F7](#s12f7---map-data-send) [F8](#s12f8---map-data-acknowledge) [F9](#s12f9---map-data-request) [F10](#s12f10---map-data-response) [F11](#s12f11---map-data-request-2) [F12](#s12f12---map-data-response-2) [F13](#s12f13---map-error-report) [F14](#s12f14---map-error-acknowledge) [F15](#s12f15---map-sample-send) [F16](#s12f16---map-sample-acknowledge) [F17](#s12f17---map-sample-request) [F18](#s12f18---map-sample-response) [F19](#s12f19---map-update-send) [F20](#s12f20---map-update-acknowledge) [F21](#s12f21---map-status-request) [F22](#s12f22---map-status-response) [F23](#s12f23---map-status-send) [F24](#s12f24---map-status-acknowledge) [F25](#s12f25---map-command-request) [F26](#s12f26---map-command-response) [F27](#s12f27---map-command-send) [F28](#s12f28---map-command-acknowledge) [F29](#s12f29---map-parameter-request) [F30](#s12f30---map-parameter-response) |
| S13 | [F1](#s13f1---data-set-upload-request) [F2](#s13f2---data-set-upload-response) [F3](#s13f3---data-set-download-request) [F4](#s13f4---data-set-download-response) [F5](#s13f5---data-set-list-request) [F6](#s13f6---data-set-list-response) [F7](#s13f7---data-set-upload-send) [F8](#s13f8---data-set-upload-acknowledge) [F9](#s13f9---data-set-download-send) [F10](#s13f10---data-set-download-acknowledge) [F11](#s13f11---data-set-list-send) [F12](#s13f12---data-set-list-acknowledge) [F13](#s13f13---data-set-format-request) [F14](#s13f14---data-set-format-response) [F15](#s13f15---data-set-format-send) [F16](#s13f16---data-set-format-acknowledge) [F17](#s13f17---data-set-validate-request) [F18](#s13f18---data-set-validate-response) [F19](#s13f19---data-set-validate-send) [F20](#s13f20---data-set-validate-acknowledge) [F21](#s13f21---data-set-compress-request) [F22](#s13f22---data-set-compress-response) [F23](#s13f23---data-set-compress-send) [F24](#s13f24---data-set-compress-acknowledge) [F25](#s13f25---data-set-decompress-request) [F26](#s13f26---data-set-decompress-response) [F27](#s13f27---data-set-decompress-send) [F28](#s13f28---data-set-decompress-acknowledge) [F29](#s13f29---data-set-encrypt-request) [F30](#s13f30---data-set-encrypt-response) [F31](#s13f31---data-set-decrypt-request) [F32](#s13f32---data-set-decrypt-response) [F33](#s13f33---data-set-backup-request) [F34](#s13f34---data-set-backup-response) [F35](#s13f35---data-set-restore-request) [F36](#s13f36---data-set-restore-response) [F37](#s13f37---data-set-archive-request) [F38](#s13f38---data-set-archive-response) [F39](#s13f39---data-set-unarchive-request) [F40](#s13f40---data-set-unarchive-response) |
| S14 | [F1](#s14f1---wafer-map-request) [F2](#s14f2---wafer-map-response) [F3](#s14f3---wafer-map-send) [F4](#s14f4---wafer-map-acknowledge) [F5](#s14f5---wafer-position-request) [F6](#s14f6---wafer-position-response) [F7](#s14f7---wafer-location-request) [F8](#s14f8---wafer-location-response) [F9](#s14f9---wafer-status-request) [F10](#s14f10---wafer-status-response) [F11](#s14f11---wafer-tracking-request) [F12](#s14f12---wafer-tracking-response) [F13](#s14f13---wafer-history-request) [F14](#s14f14---wafer-history-response) [F15](#s14f15---wafer-attribute-request) [F16](#s14f16---wafer-attribute-response) [F17](#s14f17---wafer-attribute-set) [F18](#s14f18---wafer-attribute-acknowledge) [F19](#s14f19---wafer-move-request) [F20](#s14f20---wafer-move-response) [F21](#s14f21---wafer-load-request) [F22](#s14f22---wafer-load-response) [F23](#s14f23---wafer-unload-request) [F24](#s14f24---wafer-unload-response) [F25](#s14f25---wafer-transfer-request) [F26](#s14f26---wafer-transfer-response) [F27](#s14f27---wafer-inventory-request) [F28](#s14f28---wafer-inventory-response) [F29](#s14f29---wafer-sort-request) [F30](#s14f30---wafer-sort-response) [F31](#s14f31---wafer-group-request) [F32](#s14f32---wafer-group-response) [F33](#s14f33---wafer-batch-request) [F34](#s14f34---wafer-batch-response) [F35](#s14f35---wafer-lot-request) [F36](#s14f36---wafer-lot-response) [F37](#s14f37---wafer-carrier-request) [F38](#s14f38---wafer-carrier-response) [F39](#s14f39---wafer-port-request) [F40](#s14f40---wafer-port-response) |
| S15 | [F1](#s15f1---recipe-management-multi-block-inquire) [F2](#s15f2---recipe-management-multi-block-grant) [F3](#s15f3---recipe-namespace-action-req) [F4](#s15f4---recipe-namespace-action) [F5](#s15f5---recipe-namespace-rename-req) [F6](#s15f6---recipe-namespace-rename-ack) [F7](#s15f7---recipe-space-req) [F8](#s15f8---recipe-space-data) [F9](#s15f9---recipe-status-request) [F10](#s15f10---recipe-status-data) [F11](#s15f11---recipe-version-request) [F12](#s15f12---recipe-version-data) [F13](#s15f13---recipe-create-req) [F14](#s15f14---recipe-create-ack) [F15](#s15f15---recipe-store-req) [F16](#s15f16---recipe-store-ack) [F17](#s15f17---recipe-retrieve-req) [F18](#s15f18---recipe-retrieve-data) [F19](#s15f19---recipe-rename-req) [F20](#s15f20---recipe-rename-ack) [F21](#s15f21---recipe-action-req) [F22](#s15f22---recipe-action-ack) [F23](#s15f23---recipe-descriptor-req) [F24](#s15f24---recipe-descriptor-data) [F25](#s15f25---recipe-parameter-update-req) [F26](#s15f26---recipe-parameter-update-ack) [F27](#s15f27---recipe-download-req) [F28](#s15f28---recipe-download-ack) [F29](#s15f29---recipe-verify-req) [F30](#s15f30---recipe-verify-ack) [F31](#s15f31---recipe-unload-req) [F32](#s15f32---recipe-unload-data) [F33](#s15f33---recipe-select-req) [F34](#s15f34---recipe-select-ack) [F35](#s15f35---recipe-delete-req) [F36](#s15f36---recipe-delete-ack) [F37](#s15f37---drns-segment-approve-action-req) [F38](#s15f38---drns-segment-approve-action-ack) [F39](#s15f39---drns-recorder-seg-req) [F40](#s15f40---drns-recorder-seg-ack) [F41](#s15f41---drns-recorder-mod-req) [F42](#s15f42---drns-recorder-mod-ack) [F43](#s15f43---drns-get-change-req) [F44](#s15f44---drns-get-change-ack) [F45](#s15f45---drns-mgr-seg-aprvl-req) [F46](#s15f46---drns-mgr-seg-aprvl-ack) [F47](#s15f47---drns-mgr-rebuild-req) [F48](#s15f48---drns-mgr-rebuild-ack) [F49](#s15f49---large-recipe-download-req) [F50](#s15f50---large-recipe-download-ack) [F51](#s15f51---large-recipe-upload-req) [F52](#s15f52---large-recipe-upload-ack) [F53](#s15f53---recipe-verification-send) [F54](#s15f54---recipe-verification-ack) |
| S16 | [F1](#s16f1---process-job-data-mbi) [F2](#s16f2---pjd-mbi-grant) [F3](#s16f3---process-job-create-req) [F4](#s16f4---process-job-create-ack) [F5](#s16f5---process-job-cmd-req) [F6](#s16f6---process-job-cmd-ack) [F7](#s16f7---process-job-alert-notify) [F8](#s16f8---process-job-alert-ack) [F9](#s16f9---process-job-event-notify) [F10](#s16f10---process-job-event-ack) [F11](#s16f11---prjobcreateenh) [F12](#s16f12---prjobcreateenh-ack) [F15](#s16f15---prjobmulticreate) [F16](#s16f16---prjobmulticreate-ack) [F17](#s16f17---prjobdequeue) [F18](#s16f18---prjobdequeue-ack) [F19](#s16f19---prjob-list-req) [F20](#s16f20---prjob-list-data) [F21](#s16f21---prjob-create-limit-req) [F22](#s16f22---prjob-create-limit-data) [F23](#s16f23---prjob-recipe-variable-set) [F24](#s16f24---prjob-recipe-variable-ack) [F25](#s16f25---prjob-start-method-set) [F26](#s16f26---prjob-start-method-ack) [F27](#s16f27---control-job-command) [F28](#s16f28---control-job-command-ack) [F29](#s16f29---prsetmtrlorder) [F30](#s16f30---prsetmtrlorder-ack) |
| S17 | [F1](#s17f1---data-report-create-request) [F2](#s17f2---data-report-create-response) [F3](#s17f3---data-report-send) [F4](#s17f4---data-report-acknowledge) [F5](#s17f5---data-report-list-request) [F6](#s17f6---data-report-list-response) [F7](#s17f7---data-report-list-send) [F8](#s17f8---data-report-list-acknowledge) [F9](#s17f9---collection-event-link-request) [F10](#s17f10---collection-event-link-acknowledgment) [F11](#s17f11---collection-event-unlink-request) [F12](#s17f12---collection-event-unlink-acknowledgment) [F13](#s17f13---trace-reset-request) [F14](#s17f14---trace-reset-acknowledgment) |
| S18 | [F1](#s18f1---read-attribute-request) [F2](#s18f2---read-attribute-response) [F3](#s18f3---write-attribute-request) [F4](#s18f4---write-attribute-response) [F5](#s18f5---attribute-list-request) [F6](#s18f6---attribute-list-response) [F7](#s18f7---attribute-data-send) [F8](#s18f8---attribute-data-acknowledge) [F9](#s18f9---attribute-upload-request) [F10](#s18f10---read-id-data) [F11](#s18f11---write-id-request) [F12](#s18f12---write-id-acknowledgment) [F13](#s18f13---subsystem-command) [F14](#s18f14---subsystem-command-acknowledgment) [F15](#s18f15---read-2d-code-condition-request) [F16](#s18f16---read-2d-code-condition-data) |
| S19 | [F1](#s19f1---inventory-request) [F2](#s19f2---inventory-response) [F3](#s19f3---inventory-update) [F4](#s19f4---inventory-update-response) [F5](#s19f5---inventory-add-request) [F6](#s19f6---inventory-add-response) [F7](#s19f7---inventory-remove-request) [F8](#s19f8---inventory-remove-response) [F9](#s19f9---inventory-status-request) [F10](#s19f10---inventory-status-response) [F11](#s19f11---inventory-move-request) [F12](#s19f12---inventory-move-response) [F13](#s19f13---inventory-search-request) [F14](#s19f14---inventory-search-response) [F15](#s19f15---inventory-lock-request) [F16](#s19f16---inventory-lock-response) [F17](#s19f17---inventory-history-request) [F18](#s19f18---inventory-history-response) [F19](#s19f19---inventory-audit-request) [F20](#s19f20---inventory-audit-response) |ce-data-list-response) [F7](#s19f7---trace-data-list-send) [F8](#s19f8---trace-data-list-acknowledge) [F9](#s19f9---trace-data-upload-request) [F10](#s19f10---trace-data-upload-response) [F11](#s19f11---trace-data-upload-send) [F12](#s19f12---trace-data-upload-acknowledge) [F13](#s19f13---trace-data-download-request) [F14](#s19f14---trace-data-download-response) [F15](#s19f15---trace-data-download-send) [F16](#s19f16---trace-data-download-acknowledge) [F17](#s19f17---trace-data-validate-request) [F18](#s19f18---trace-data-validate-response) [F19](#s19f19---trace-data-validate-send) [F20](#s19f20---trace-data-validate-acknowledge) [F21](#s19f21---trace-data-compress-request) [F22](#s19f22---trace-data-compress-response) [F23](#s19f23---trace-data-compress-send) [F24](#s19f24---trace-data-compress-acknowledge) [F25](#s19f25---trace-data-encrypt-request) [F26](#s19f26---trace-data-encrypt-response) [F27](#s19f27---trace-data-encrypt-send) [F28](#s19f28---trace-data-encrypt-acknowledge) [F29](#s19f29---trace-data-decrypt-request) [F30](#s19f30---trace-data-decrypt-response) [F31](#s19f31---trace-data-decrypt-send) [F32](#s19f32---trace-data-decrypt-acknowledge) [F33](#s19f33---trace-data-backup-request) [F34](#s19f34---trace-data-backup-response) [F35](#s19f35---trace-data-restore-request) [F36](#s19f36---trace-data-restore-response) [F37](#s19f37---trace-data-archive-request) [F38](#s19f38---trace-data-archive-response) [F39](#s19f39---trace-data-unarchive-request) [F40](#s19f40---trace-data-unarchive-response) |
| S20 | [F1](#s20f1---setsro-attributes-request) [F2](#s20f2---setsro-attributes-acknowledge) [F3](#s20f3---getoperationidlist-request) [F4](#s20f4---getoperationidlist-acknowledge) [F5](#s20f5---openconnectionevent-send) [F6](#s20f6---openconnectionevent-acknowledge) [F7](#s20f7---closeconnectionevent-send) [F8](#s20f8---closeconnectionevent-acknowledge) [F9](#s20f9---clearoperation-request) [F10](#s20f10---clearoperation-acknowledge) [F11](#s20f11---getrecipexidlist-request) [F12](#s20f12---getrecipexidlist-acknowledge) [F13](#s20f13---deleterecipe-request) [F14](#s20f14---deleterecipe-acknowledge) [F15](#s20f15---writerecipe-request) [F16](#s20f16---writerecipe-acknowledge) [F17](#s20f17---readrecipe-request) [F18](#s20f18---readrecipe-acknowledge) [F19](#s20f19---queryrecipexidlist-event-send) [F20](#s20f20---queryrecipexidlist-event-acknowledge) [F21](#s20f21---queryrecipe-event-send) [F22](#s20f22---queryrecipe-event-acknowledge) [F23](#s20f23---postrecipe-event-send) [F24](#s20f24---postrecipe-event-acknowledge) [F25](#s20f25---setprc-attributes-request) [F26](#s20f26---setprc-attributes-acknowledge) [F27](#s20f27---prespecifyrecipe-request) [F28](#s20f28---prespecifyrecipe-acknowledge) [F29](#s20f29---querypjrecipexidlist-event-send) [F30](#s20f30---querypjrecipexidlist-event-acknowledge) [F31](#s20f31---pre-exe-check-event-send) [F32](#s20f32---pre-exe-check-event-acknowledge) [F33](#s20f33---prespecifyrecipe-event-send) [F34](#s20f34---prespecifyrecipe-event-acknowledge) |
| S21 | [F1](#s21f1---material-transfer-plan) [F2](#s21f2---material-transfer-plan-response) [F3](#s21f3---item-send) [F4](#s21f4---item-send-acknowledge) [F5](#s21f5---item-request) [F6](#s21f6---item-data) [F7](#s21f7---item-type-list-request) [F8](#s21f8---item-type-list-results) [F9](#s21f9---supported-item-type-list-request) [F10](#s21f10---supported-item-type-list-result) [F11](#s21f11---item-delete) [F12](#s21f12---item-delete-acknowledge) [F13](#s21f13---request-permission-to-send-item) [F14](#s21f14---grant-permission-to-send-item) [F15](#s21f15---item-request) [F16](#s21f16---item-request-grant) [F17](#s21f17---send-item-part) [F18](#s21f18---send-item-part-acknowledge) [F19](#s21f19---item-type-feature-support) [F20](#s21f20---item-type-feature-support-results) |


## Overview

**SECS/GEM** (Semiconductor Equipment Communications Standard/Generic Equipment Model) is a comprehensive communication protocol suite specifically designed for semiconductor manufacturing equipment. Developed by SEMI (Semiconductor Equipment and Materials International), it provides standardized methods for equipment communication, control, and data collection in semiconductor fabrication facilities.

## Core Communication Concepts

SECS defines a standardized communication protocol for semiconductor manufacturing equipment, enabling consistent equipment integration and automation through stream and function organization, where streams (S1-S127) categorize message types by functionality and functions (F1-F255) define specific operations within each stream.

## SECS-II Data Format {#secs-ii-data-format}

SECS-II defines a comprehensive data format specification for message structure and data representation in semiconductor equipment communication. The format supports hierarchical data organization through nested lists and various data types.

### Data Types

#### Numeric Data Types
- **U1**: 1-byte unsigned integer (0-255)
- **U2**: 2-byte unsigned integer (0-65535)
- **U4**: 4-byte unsigned integer (0-4294967295)
- **U8**: 8-byte unsigned integer
- **I1**: 1-byte signed integer (-128 to 127)
- **I2**: 2-byte signed integer (-32768 to 32767)
- **I4**: 4-byte signed integer (-2147483648 to 2147483647)
- **I8**: 8-byte signed integer
- **F4**: 4-byte floating point (IEEE 754 single precision)
- **F8**: 8-byte floating point (IEEE 754 double precision)

#### Text and Binary Data Types
- **A**: ASCII text string (printable characters)
- **B**: Binary data (raw bytes)
- **J**: JIS-8 Japanese text string
- **U**: Unicode text string

#### Structured Data Types
- **L**: List (container for multiple items)
- **BOOLEAN**: Boolean value (TRUE/FALSE)

### Message Structure

#### Basic Format
```
{L[n]
  item_1
  item_2
  ...
  item_n
}
```

```
```

- **L[n]**: List containing n items
- **item**: Individual data element of any supported type

#### Nested Lists
Lists can contain other lists, creating hierarchical data structures:
```
{L[2]
  {L[3]
    item_1_1
    item_1_2
    item_1_3
  }
  {L[2]
    item_2_1
    item_2_2
  }
}
```

#### Empty Data
- **Empty Message**: No data content
- **Empty List**: `{L:0}` - List with zero items

### Data Encoding

#### Length Encoding
Each data item includes:
1. **Format Code**: 1 byte specifying data type
2. **Length**: Variable length field (1-4 bytes)
3. **Data**: Actual data content

#### Format Code Structure
- **Bits 7-2**: Data type identifier
- **Bits 1-0**: Length field size (0-3 bytes)

#### Example Encodings
```
ASCII String "HELLO":
-  0x41 (ASCII, 1-byte length)
- Length: 0x05 (5 characters)
- Data: 0x48 0x45 0x4C 0x4C 0x4F

U2 Value 1000:
-  0xA9 (U2, 2-byte length)
- Length: 0x00 0x02 (2 bytes)
- Data: 0x03 0xE8 (1000 in big-endian)

List with 2 items:
-  0x01 (List, 1-byte length)
- Length: 0x02 (2 items)
- Data: [encoded items]
```

### Message Validation

#### Requirements
- All numeric data must be in big-endian (network) byte order
- ASCII strings must contain only printable characters (0x20-0x7E)
- Lists must accurately specify item count
- Message structure must match stream/function specification

#### Error Conditions
- Invalid data type for message context
- Incorrect data length
- Malformed list structure
- Character encoding violations

## Stream Definitions

### Stream 1: Equipment Status
**Purpose**: Equipment state information and basic communication

| Message | Direction | Description |
|---------|-----------|-------------|
| [S1F1](#s1f1---are-you-there-request)    | → Equipment | Are You There (Request) |
| [S1F2](#s1f2---are-you-there-response)    | ← Equipment | Are You There (Response) |
| [S1F3](#s1f3r---selected-equipment-status-request)    | → Equipment | Selected Equipment Status Request |
| [S1F4](#s1f4---selected-equipment-status-data)    | ← Equipment | Selected Equipment Status Data |
| [S1F5](#s1f5r---formatted-status-request)    | → Equipment | Formatted Status Request |
| [S1F6](#s1f6---formatted-status-data)    | ← Equipment | Formatted Status Data |
| [S1F7](#s1f7---fixed-form-request)    | → Equipment | Fixed Form Request |
| [S1F8](#s1f8---fixed-form-data)    | ← Equipment | Fixed Form Data |
| [S1F9](#s1f9r---material-transfer-status-request)    | → Equipment | Material Transfer Status Request |
| [S1F10](#s1f10---material-transfer-status-data)    | ← Equipment | Material Transfer Status Data |
| [S1F11](#s1f11r---status-variable-namelist-request)   | → Equipment | Status Variable Namelist Request |
| [S1F12](#s1f12---status-variable-namelist-reply)   | ← Equipment | Status Variable Namelist Reply |
| [S1F13](#s1f13r---establish-communications-request)   | → Equipment | Establish Communications Request |
| [S1F14](#s1f14---establish-communications-request-acknowledge)   | ← Equipment | Establish Communications Request Acknowledge |
| [S1F15](#s1f15r---request-offline)   | → Equipment | Request OFF-LINE |
| [S1F16](#s1f16---offline-acknowledge)   | ← Equipment | OFF-LINE Acknowledge |
| [S1F17](#s1f17r---request-online)   | → Equipment | Request ON-LINE |
| [S1F18](#s1f18---online-acknowledge)   | ← Equipment | ON-LINE Acknowledge |
| [S1F19](#s1f19r---get-attribute)   | → Equipment | Get Attribute |
| [S1F20](#s1f20---attribute-data)   | ← Equipment | Attribute Data |
| [S1F21](#s1f21r---data-variable-namelist-request)   | → Equipment | Data Variable Namelist Request |
| [S1F22](#s1f22---data-variable-namelist-reply)   | ← Equipment | Data Variable Namelist Reply |
| [S1F23](#s1f23r---collection-event-namelist-request)   | → Equipment | Collection Event Namelist Request |
| [S1F24](#s1f24---collection-event-namelist-reply)   | ← Equipment | Collection Event Namelist Reply |

#### **S1F1 - Are You There (Request)** {#s1f1---are-you-there-request}
```
{}
```

#### **S1F2 - Are You There (Response)** {#s1f2---are-you-there-response}
```
{} 
or
{L:0}
```

#### **S1F3 - Selected Equipment Status Request** {#s1f3r---selected-equipment-status-request}	
```
  {L[n]
    SVID
  }
```

#### **S1F4	Selected Equipment Status Data** {#s1f4---selected-equipment-status-data}
``` 
{L[n]
  SV
} 
```

#### **S1F5	Formatted Status Request** {#s1f5r---formatted-status-request}
``` 
SFCD
```

#### **S1F6	Formatted Status Data** {#s1f6---formatted-status-data}
```
{L[n]
  SV
}
```

#### **S1F7	Fixed Form Request** {#s1f7---fixed-form-request} 
```
SFCD
```

#### **S1F8	Fixed Form Data** {#s1f8---fixed-form-data}

```
{L[n]
  {L[2]
  SVNAME
  SV0
  }
}
```

#### **S1F9	Material Transfer Status Request** {#s1f9r---material-transfer-status-request} 
```
{}

```
#### **S1F10	Material Transfer Status Data** {#s1f10---material-transfer-status-data} 
 
```
{L[2]
  TSIP
  TSOP
}
```

#### **S1F11	Status Variable Namelist Request** {#s1f11r---status-variable-namelist-request}	 

```
{L[n]
  SVID
}
```

#### **S1F12	Status Variable Namelist Reply** {#s1f12---status-variable-namelist-reply}	

```
{L[n]
  {L[3]
    SVID
    SVNAME
    UNITS
  }
}
```

#### **S1F13R	Establish Communications Request** {#s1f13r---establish-communications-request}

```

P->
{L[2]
  MDLN
  SOFTREV
}

A->
L[0]

```
#### **S1F14	Establish Communications Request Acknowledge** {#s1f14---establish-communications-request-acknowledge}

```
P->
{L[2]
  COMMACK
  {L[2]
    MDLN
    SOFTREV
  }
}

A->
{L[2]
  COMMACK
  L:0
}
```
#### **S1F15R	Request OFF-LINE** {#s1f15r---request-offline}	
```
{}
```
#### **S1F16	OFF-LINE Acknowledge** {#s1f16---offline-acknowledge}	
```
OFLACK
```
#### **S1F17R	Request ON-LINE** {#s1f17r---request-online}	
```
{}
```
#### **S1F18	ON-LINE Acknowledge** {#s1f18---online-acknowledge}	
```
ONLACK
```
#### **S1F19R	Get Attribute** {#s1f19r---get-attribute}	
```
{L[3]
  OBJTYPE
  {L[n]
    OBJID
  }
  {L[n]
    ATTRID
  }
}
```
#### **S1F20	Attribute Data** {#s1f20---attribute-data}	
```
{L[2]
  {L[n]
    {L[n]
    ATTRDATA
    }
    }
    {L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```
#### **S1F21R	Data Variable Namelist Request** {#s1f21r---data-variable-namelist-request}	
```
{L[n]
  VID
}
```
#### **S1F22	Data Variable Namelist Reply** {#s1f22---data-variable-namelist-reply}	

```
{L[n]
  {L[3]
    VID
    DVVALNAME
    UNITS
  }
}

```
#### **S1F23R	Collection Event Namelist Request** {#s1f23r---collection-event-namelist-request}
```
{L[n]
  CEID
}
```
#### **S1F24	Collection Event Namelist Reply** {#s1f24---collection-event-namelist-reply}
```
{L[n]
  {L[3]
    CEID
    CENAME
    {L[n]
     VID
    }
  }
}
```
### Stream 2: Equipment Control and Diagnostics
**Purpose**: Equipment configuration and diagnostic operations

| Message | Direction | Description |
|---------|-----------|-------------|
| [S2F1](#s2f1---equipment-status-request)    | → Equipment | Equipment Status Request |
| [S2F2](#s2f2---equipment-status-response)    | ← Equipment | Equipment Status Response |
| [S2F3](#s2f3---status-variable-value-request)    | → Equipment | Status Variable Value Request |
| [S2F4](#s2f4---status-variable-value-response)    | ← Equipment | Status Variable Value Response |
| [S2F5](#s2f5---send-equipment-status)    | ← Equipment | Send Equipment Status |
| [S2F6](#s2f6---send-equipment-status-acknowledge)    | → Equipment | Send Equipment Status Acknowledge |
| [S2F7](#s2f7---load-port-status-request)    | → Equipment | Load Port Status Request |
| [S2F8](#s2f8---load-port-status-response)    | ← Equipment | Load Port Status Response |
| [S2F9](#s2f9---equipment-status-multi-block-inquire)    | → Equipment | Equipment Status Multi-Block Inquire |
| [S2F10](#s2f10---equipment-status-multi-block-grant)   | ← Equipment | Equipment Status Multi-Block Grant |
| [S2F11](#s2f11---equipment-status-multi-block)   | ← Equipment | Equipment Status Multi-Block |
| [S2F12](#s2f12---equipment-status-multi-block-acknowledge)   | → Equipment | Equipment Status Multi-Block Acknowledge |
| [S2F13](#s2f13---equipment-constant-request)   | → Equipment | Equipment Constant Request |
| [S2F14](#s2f14---equipment-constant-response)   | ← Equipment | Equipment Constant Response |
| [S2F15](#s2f15---new-equipment-constant-send)   | → Equipment | New Equipment Constant Send |
| [S2F16](#s2f16---new-equipment-constant-acknowledge)   | ← Equipment | New Equipment Constant Acknowledge |
| [S2F17](#s2f17---date-and-time-request)   | → Equipment | Date and Time Request |
| [S2F18](#s2f18---date-and-time-response)   | ← Equipment | Date and Time Response |
| [S2F19](#s2f19---recipe-body-request)   | → Equipment | Recipe Body Request |
| [S2F20](#s2f20---recipe-body-response)   | ← Equipment | Recipe Body Response |
| [S2F21](#s2f21---recipe-body-send)   | → Equipment | Recipe Body Send |
| [S2F22](#s2f22---recipe-body-acknowledge)   | ← Equipment | Recipe Body Acknowledge |
| [S2F23](#s2f23---trace-initialize-send)   | → Equipment | Trace Initialize Send |
| [S2F24](#s2f24---trace-initialize-acknowledge)   | ← Equipment | Trace Initialize Acknowledge |
| [S2F25](#s2f25---loopback-diagnostic-request)   | → Equipment | Loopback Diagnostic Request |
| [S2F26](#s2f26---loopback-diagnostic-response)   | ← Equipment | Loopback Diagnostic Response |
| [S2F27](#s2f27---initiate-processing-request)   | → Equipment | Initiate Processing Request |
| [S2F28](#s2f28---initiate-processing-acknowledge)   | ← Equipment | Initiate Processing Acknowledge |
| [S2F29](#s2f29---equipment-constant-namelist-request)   | → Equipment | Equipment Constant Namelist Request |
| [S2F30](#s2f30---equipment-constant-namelist-response)   | ← Equipment | Equipment Constant Namelist Response |
| [S2F31](#s2f31---date-and-time-set-request)   | → Equipment | Date and Time Set Request |
| [S2F32](#s2f32---date-and-time-set-response)   | ← Equipment | Date and Time Set Response |
| [S2F33](#s2f33---define-report)   | → Equipment | Define Report |
| [S2F34](#s2f34---define-report-acknowledge)   | ← Equipment | Define Report Acknowledge |
| [S2F35](#s2f35---link-event-report)   | → Equipment | Link Event Report |
| [S2F36](#s2f36---link-event-report-acknowledge)   | ← Equipment | Link Event Report Acknowledge |
| [S2F37](#s2f37---enabledisable-event-report)   | → Equipment | Enable/Disable Event Report |
| [S2F38](#s2f38---enabledisable-event-report-acknowledge)   | ← Equipment | Enable/Disable Event Report Acknowledge |
| [S2F39](#s2f39---status-variable-namelist-request)   | → Equipment | Status Variable Namelist Request |
| [S2F40](#s2f40---status-variable-namelist-response)   | ← Equipment | Status Variable Namelist Response |
| [S2F41](#s2f41---host-command-send)   | → Equipment | Host Command Send |
| [S2F42](#s2f42---host-command-acknowledge)   | ← Equipment | Host Command Acknowledge |
| [S2F43](#s2f43---reset-spooling-streams-and-functions)   | → Equipment | Reset Spooling Streams and Functions |
| [S2F44](#s2f44---reset-spooling-acknowledge)   | ← Equipment | Reset Spooling Acknowledge |
| [S2F45](#s2f45---define-variable-limit-attributes)   | → Equipment | Define Variable Limit Attributes |
| [S2F46](#s2f46---define-variable-limit-attributes-acknowledge)   | ← Equipment | Define Variable Limit Attributes Acknowledge |
| [S2F47](#s2f47---variable-limit-attribute-request)   | → Equipment | Variable Limit Attribute Request |
| [S2F48](#s2f48---variable-limit-attribute-response)   | ← Equipment | Variable Limit Attribute Response |
| [S2F49](#s2f49---enhanced-remote-command)   | → Equipment | Enhanced Remote Command |
| [S2F50](#s2f50---enhanced-remote-command-acknowledge)   | ← Equipment | Enhanced Remote Command Acknowledge |
| [S2F51](#s2f51---automated-substrate-mapping)   | → Equipment | Automated Substrate Mapping |
| [S2F52](#s2f52---automated-substrate-mapping-acknowledge)   | ← Equipment | Automated Substrate Mapping Acknowledge |
| [S2F53](#s2f53---enhanced-define-report)   | → Equipment | Enhanced Define Report |
| [S2F54](#s2f54---enhanced-define-report-acknowledge)   | ← Equipment | Enhanced Define Report Acknowledge |
| [S2F55](#s2f55---enhanced-link-event-report)   | → Equipment | Enhanced Link Event Report |
| [S2F56](#s2f56---enhanced-link-event-report-acknowledge)   | ← Equipment | Enhanced Link Event Report Acknowledge |
| [S2F57](#s2f57---enhanced-enabledisable-event-report)   | → Equipment | Enhanced Enable/Disable Event Report |
| [S2F58](#s2f58---enhanced-enabledisable-event-report-acknowledge)   | ← Equipment | Enhanced Enable/Disable Event Report Acknowledge |
| [S2F59](#s2f59---formatted-process-program-send)   | → Equipment | Formatted Process Program Send |
| [S2F60](#s2f60---formatted-process-program-acknowledge)   | ← Equipment | Formatted Process Program Acknowledge |
| [S2F61](#s2f61---formatted-process-program-request)   | → Equipment | Formatted Process Program Request |
| [S2F62](#s2f62---formatted-process-program-response)   | ← Equipment | Formatted Process Program Response |
| [S2F63](#s2f63---define-object)   | → Equipment | Define Object |
| [S2F64](#s2f64---define-object-acknowledge)   | ← Equipment | Define Object Acknowledge |

#### **S2F1 - Equipment Status Request** {#s2f1---equipment-status-request}
```
{L[n]
  SVID_1
  SVID_2
  ...
  SVID_n
}
```

**Parameters:**
- SVID: Status Variable ID (U1, U2, U4, or A)


#### **S2F2 - Equipment Status Response** {#s2f2---equipment-status-response}
```
{L[n]
  SV_1
  SV_2
  ...
  SV_n
}
```

**Parameters:**
- SV: Status Variable Value (corresponding to SVID in S2F1)


#### **S2F3 - Status Variable Value Request** {#s2f3---status-variable-value-request}
```
{L[n]
  SVID_1
  SVID_2
  ...
  SVID_n
}
```

**Parameters:**
- SVID: Status Variable ID (U1, U2, U4, or A)


#### **S2F4 - Status Variable Value Response** {#s2f4---status-variable-value-response}
```
{L[n]
  SV_1
  SV_2
  ...
  SV_n
}
```

**Parameters:**
- SV: Status Variable Value (corresponding to SVID in S2F3)


#### **S2F5 - Send Equipment Status** {#s2f5---send-equipment-status}
```
{L[n]
  SV_1
  SV_2
  ...
  SV_n
}
```

**Parameters:**
- SV: Status Variable Value (U1, U2, U4, or A)


#### **S2F6 - Send Equipment Status Acknowledge** {#s2f6---send-equipment-status-acknowledge}
```
{}
```

**Parameters:**
- Empty list (acknowledgment)


#### **S2F7 - Load Port Status Request** {#s2f7---load-port-status-request}
```
{}
```

**Parameters:**
- Empty list (request for all load port status)


#### **S2F8 - Load Port Status Response** {#s2f8---load-port-status-response}
```
{L[n]
  {L[2]
    PORTID
    PORTSTATUS
  }
}
```

**Parameters:**
- PORTID: Port Identifier (U1, U2, U4, or A)
- PORTSTATUS: Port Status (U1, U2, U4, or A)


#### **S2F9 - Equipment Status Multi-Block Inquire** {#s2f9---equipment-status-multi-block-inquire}
```
{L[n]
  SVID_1
  SVID_2
  ...
  SVID_n
}
```

**Parameters:**
- SVID: Status Variable ID (U1, U2, U4, or A)


#### **S2F10 - Equipment Status Multi-Block Grant** {#s2f10---equipment-status-multi-block-grant}
```
GRANT
```

**Parameters:**
- GRANT: Grant permission for multi-block transfer


#### **S2F11 - Equipment Status Multi-Block** {#s2f11---equipment-status-multi-block}
```
{L[n]
  SV_1
  SV_2
          ...
  SV_n
}
```

**Parameters:**
- SV: Status Variable Value (corresponding to SVID in S2F9)


#### **S2F12 - Equipment Status Multi-Block Acknowledge** {#s2f12---equipment-status-multi-block-acknowledge}
```
{}
```

**Parameters:**
- Empty list (acknowledgment)


#### **S2F13 - Equipment Constant Request** {#s2f13---equipment-constant-request}
```
{L[n]
  ECID_1
  ECID_2
          ...
  ECID_n
}
```

**Parameters:**
- ECID: Equipment Constant ID (U1, U2, U4, or A)


#### **S2F14 - Equipment Constant Response** {#s2f14---equipment-constant-response}
```
{L[n]
  ECV_1
  ECV_2
  ...
  ECV_n
}
```

**Parameters:**
- ECV: Equipment Constant Value (corresponding to ECID in S2F13)


#### **S2F15 - New Equipment Constant Send** {#s2f15---new-equipment-constant-send}
```
  {L[n]
  {L[2]
    ECID_1
    ECV_1
  }
  {L[2]
    ECID_2
    ECV_2
  }
  ...
  {L[2]
    ECID_n
    ECV_n
  }
}
```

**Parameters:**
- ECID: Equipment Constant ID (U1, U2, U4, or A)
- ECV: Equipment Constant Value (U1, U2, U4, or A)


#### **S2F16 - New Equipment Constant Acknowledge** {#s2f16---new-equipment-constant-acknowledge}
```
EAC
```

**Parameters:**
- EAC: Equipment Acknowledge Code (U1, U2, U4, or A)


#### **S2F17 - Date and Time Request** {#s2f17---date-and-time-request}
```
{}
```

**Parameters:**
- Empty list (request for current date and time)


#### **S2F18 - Date and Time Response** {#s2f18---date-and-time-response}
```
TIME
```

**Parameters:**
- TIME: Date and Time value (A)


#### **S2F19 - Recipe Body Request** {#s2f19---recipe-body-request}
```
  {L[2]
  RCMD
  RPARM
  }
```

**Parameters:**
- RCMD: Recipe Command (A)
- RPARM: Recipe Parameter (A)


#### **S2F20 - Recipe Body Response** {#s2f20---recipe-body-response}
```
{L[2]
  RCMD
  RPARM
}
```

**Parameters:**
- RCMD: Recipe Command (A)
- RPARM: Recipe Parameter (A)


#### **S2F21 - Recipe Body Send** {#s2f21---recipe-body-send}
```
{L[2]
  RCMD
  RPARM
}
```

**Parameters:**
- RCMD: Recipe Command (A)
- RPARM: Recipe Parameter (A)


#### **S2F22 - Recipe Body Acknowledge** {#s2f22---recipe-body-acknowledge}
```
CMDA
```

**Parameters:**
- CMDA: Command Acknowledge (A)


#### **S2F23 - Trace Initialize Send** {#s2f23---trace-initialize-send}
```
{L[5]
  TRID
  DSPER
  TOTSMP
  REPGSZ
  {L[n]
    SVID
}
}
```

**Parameters:**
- TRID: Trace ID (A)
- DSPER: Display Period (U1, U2, U4)
- TOTSMP: Total Samples (U1, U2, U4)
- REPGSZ: Report Page Size (U1, U2, U4)
- SVID: Status Variable ID (U1, U2, U4, or A)


#### **S2F24 - Trace Initialize Acknowledge** {#s2f24---trace-initialize-acknowledge}
```
TIAACK
```

**Parameters:**
- TIAACK: Trace Initialize Acknowledge (A)


#### **S2F25 - Loopback Diagnostic Request** {#s2f25---loopback-diagnostic-request}
```
ABS
```

**Parameters:**
- ABS: Arbitrary Binary String (B)


#### **S2F26 - Loopback Diagnostic Response** {#s2f26---loopback-diagnostic-response}
```
ABS
```

**Parameters:**
- ABS: Arbitrary Binary String (B)


#### **S2F27 - Initiate Processing Request** {#s2f27---initiate-processing-request}
```
{L[3]
  LOC
  PPID
  {L[n]
    MID
  }
}
```

**Parameters:**
- LOC: Location (A)
- PPID: Process Program ID (A)
- MID: Material ID (A)


#### **S2F28 - Initiate Processing Acknowledge** {#s2f28---initiate-processing-acknowledge}
```
CMDA
```

**Parameters:**
- CMDA: Command Acknowledge (A)


#### **S2F29 - Equipment Constant Namelist Request** {#s2f29---equipment-constant-namelist-request}
```
{L[n]
  ECID_1
  ECID_2
  ...
  ECID_n
}
```

**Parameters:**
- ECID: Equipment Constant ID (U1, U2, U4, or A)


#### **S2F30 - Equipment Constant Namelist Response** {#s2f30---equipment-constant-namelist-response}
```
{L[n]
  {L[6]
    ECID
    ECNAME
    ECMIN
    ECMAX
    ECDEF
    UNITS
  }
}
```

**Parameters:**
- ECID: Equipment Constant ID (U1, U2, U4, or A)
- ECNAME: Equipment Constant Name (A)
- ECMIN: Equipment Constant Minimum Value (U1, U2, U4, or A)
- ECMAX: Equipment Constant Maximum Value (U1, U2, U4, or A)
- ECDEF: Equipment Constant Default Value (U1, U2, U4, or A)
- UNITS: Units (A)


#### **S2F31 - Date and Time Set Request** {#s2f31---date-and-time-set-request}
```
TIME
```

**Parameters:**
- TIME: Date and Time value (A)


#### **S2F32 - Date and Time Set Response** {#s2f32---date-and-time-set-response}
```
TIACK
```

**Parameters:**
- TIACK: Time Acknowledge (A)


#### **S2F33 - Define Report** {#s2f33---define-report}
```
{L[2]
  DATAID
  {L[n]
    {L[2]
      RPTID
      {L[n]
        VID
  }
}
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)


#### **S2F34 - Define Report Acknowledge** {#s2f34---define-report-acknowledge}
```
DRACK
```

**Parameters:**
- DRACK: Define Report Acknowledge (A)


#### **S2F35 - Link Event Report** {#s2f35---link-event-report}
```
{L[2]
  DATAID
{L[n]
    {L[2]
      CEID
      {L[n]
        RPTID
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)


#### **S2F36 - Link Event Report Acknowledge** {#s2f36---link-event-report-acknowledge}
```
LRACK
```

**Parameters:**
- LRACK: Link Event Report Acknowledge (A)


#### **S2F37 - Enable/Disable Event Report** {#s2f37---enabledisable-event-report}
```
{L[2]
  CEED
  {L[n]
    CEID
  }
}
```

**Parameters:**
- CEED: Collection Event Enable/Disable (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)


#### **S2F38 - Enable/Disable Event Report Acknowledge** {#s2f38---enabledisable-event-report-acknowledge}
```
ERACK
```

**Parameters:**
- ERACK: Event Report Acknowledge (A)


#### **S2F39 - Status Variable Namelist Request** {#s2f39---status-variable-namelist-request}
```
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- DATALENGTH: Data Length (U1, U2, U4)


#### **S2F40 - Status Variable Namelist Response** {#s2f40---status-variable-namelist-response}
```
GRANT
```

**Parameters:**
- GRANT: Grant permission for multi-block transfer


#### **S2F41 - Host Command Send** {#s2f41---host-command-send}
```
{L[2]
  RCMD
  {L[n]
    {L[2]
      CPNAME
      CPVAL
  }
}
}
```

**Parameters:**
- RCMD: Remote Command (A)
- CPNAME: Command Parameter Name (A)
- CPVAL: Command Parameter Value (A)


#### **S2F42 - Host Command Acknowledge** {#s2f42---host-command-acknowledge}
```
{L[2]
  HCACK
    {L[n]
      {L[2]
        CPNAME
        CPACK
      }
    }
}
```

**Parameters:**
- HCACK: Host Command Acknowledge (A)
- CPNAME: Command Parameter Name (A)
- CPACK: Command Parameter Acknowledge (A)


#### **S2F43 - Reset Spooling Streams and Functions** {#s2f43---reset-spooling-streams-and-functions}
```
{L[n]
{L[2]
  STRID
    {L[n]
  FCNID
}
  }
}
```

**Parameters:**
- STRID: Stream ID (U1, U2, U4, or A)
- FCNID: Function ID (U1, U2, U4, or A)


#### **S2F44 - Reset Spooling Acknowledge** {#s2f44---reset-spooling-acknowledge}
```
{L[2]
RSPACK
  {L[n]
    {L[3]
      STRID
      STRACK
      {L[n]
        FCNID
      }
    }
  }
}
```

**Parameters:**
- RSPACK: Reset Spooling Acknowledge (A)
- STRID: Stream ID (U1, U2, U4, or A)
- STRACK: Stream Acknowledge (A)
- FCNID: Function ID (U1, U2, U4, or A)


#### **S2F45 - Define Variable Limit Attributes** {#s2f45---define-variable-limit-attributes}
```
{L[2]
  DATAID
{L[n]
    {L[2]
    VID
      {L[n]
        {L[2]
    LIMITID
          {L[2]
    UPPERDB
    LOWERDB
          }
        }
      }
  }
}
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)
- LIMITID: Limit ID (U1, U2, U4, or A)
- UPPERDB: Upper Database (U1, U2, U4, or A)
- LOWERDB: Lower Database (U1, U2, U4, or A)


#### **S2F46 - Define Variable Limit Attributes Acknowledge** {#s2f46---define-variable-limit-attributes-acknowledge}
```
{L[2]
  VLAACK
  {L[n]
    {L[3]
      VID
      LVACK
      {L[2]
        LIMITID
        LIMITACK
      }
    }
  }
}
```

**Parameters:**
- VLAACK: Variable Limit Attributes Acknowledge (A)
- VID: Variable ID (U1, U2, U4, or A)
- LVACK: Limit Value Acknowledge (A)
- LIMITID: Limit ID (U1, U2, U4, or A)
- LIMITACK: Limit Acknowledge (A)


#### **S2F47 - Variable Limit Attribute Request** {#s2f47---variable-limit-attribute-request}
```
{L[n]
  VID_1
  VID_2
  ...
  VID_n
}
```

**Parameters:**
- VID: Variable ID (U1, U2, U4, or A)


#### **S2F48 - Variable Limit Attribute Response** {#s2f48---variable-limit-attribute-response}
```
{L[n]
  {L[2]
    VID
    {L[4]
      UNITS
      LIMITMIN
      LIMITMAX
      {L[n]
        {L[3]
    LIMITID
    UPPERDB
    LOWERDB
  }
}
    }
  }
}
```

**Parameters:**
- VID: Variable ID (U1, U2, U4, or A)
- UNITS: Units (A)
- LIMITMIN: Limit Minimum (U1, U2, U4, or A)
- LIMITMAX: Limit Maximum (U1, U2, U4, or A)
- LIMITID: Limit ID (U1, U2, U4, or A)
- UPPERDB: Upper Database (U1, U2, U4, or A)
- LOWERDB: Lower Database (U1, U2, U4, or A)


#### **S2F49 - Enhanced Remote Command** {#s2f49---enhanced-remote-command}
```
{L[4]
  RCMD
      CPNAME
  CEPVAL
      CPACK
    }
```

**Parameters:**
- RCMD: Remote Command (A)
- CPNAME: Command Parameter Name (A)
- CEPVAL: Command Parameter Value (A)
- CPACK: Command Parameter Acknowledge (A)


#### **S2F50 - Enhanced Remote Command Acknowledge** {#s2f50---enhanced-remote-command-acknowledge}
```
{L[2]
  HCACK
  {L[n]
    {L[2]
      CPNAME
      CEPACK
    }
  }
}
```

**Parameters:**
- HCACK: Host Command Acknowledge (A)
- CPNAME: Command Parameter Name (A)
- CEPACK: Command Parameter Acknowledge (A)


#### **S2F51 - Request Report Identifiers** {#s2f51---request-report-identifiers}
```
header only
```
 


#### **S2F52 - Return Report Identifiers** {#s2f52---return-report-identifiers}
```
  {L[n]
  RPTID
}
```
**Parameters:**
- RPTID: Report ID (U1, U2, U4, or A)


#### **S2F53 - Request Report Definitions** {#s2f53---request-report-definitions}
```
{L[n]
  RPTID
}
```
**Parameters:**
- RPTID: Report ID (U1, U2, U4, or A)


#### **S2F54 - Return Report Definitions** {#s2f54---return-report-definitions}
```
  {L[n]
    {L[2]
      RPTID
    {L[n]
      VID
    }
  }
}
```
**Parameters:**
- RPTID: Report ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)


#### **S2F55 - Request Event Report Links** {#s2f55---request-event-report-links}
```
{L[n]
  CEID
}
```
**Parameters:**
- CEID: Collection Event ID (U1, U2, U4, or A)


#### **S2F56 - Return Event Report Links** {#s2f56---return-event-report-links}
```
  {L[n]
  {L[3]
      CEID
    CENAME
    {L[n]
      RPTID
    }
  }
}
```
**Parameters:**
- CEID: Collection Event ID (U1, U2, U4, or A)
- CENAME: Collection Event Name (A)
- RPTID: Report ID (U1, U2, U4, or A)


#### **S2F57 - Request Enabled Events** {#s2f57---request-enabled-events}
```
{}
```
 

#### **S2F58 - Return Enabled Events** {#s2f58---return-enabled-events}
```
  {L[n]
  CEID
  }
```
**Parameters:**
- CEID: Collection Event ID (U1, U2, U4, or A)


#### **S2F59 - Request Spool Streams and Functions** {#s2f59---request-spool-streams-and-functions}
```
{}
```


#### **S2F60 - Return Spool Streams and Functions** {#s2f60---return-spool-streams-and-functions}
```
{L[n]
  {L[2]
    STRID
    {L[n]
      FCNID
    }
  }
}
```
**Parameters:**
- STRID: Stream ID (U1, U2, U4, or A)
- FCNID: Function ID (U1, U2, U4, or A)


#### **S2F61 - Request Trace Identifiers** {#s2f61---request-trace-identifiers}
```
{}
```
 

#### **S2F62 - Return Trace Identifiers** {#s2f62---return-trace-identifiers}
```
{L[n]
  TRID
}
```
**Parameters:**
- TRID: Trace ID (A)


#### **S2F63 - Request Trace Definitions** {#s2f63---request-trace-definitions}
```
{L[n]
  TRID
}
```
**Parameters:**
- TRID: Trace ID (A)


#### **S2F64 - Return Trace Definitions** {#s2f64---return-trace-definitions}
```
  {L[n]
  {L[5]
    TRID
    DSPER
    TOTSMP
    REPGSZ
    {L[n]
      SVID
      }
    }
  }
```
**Parameters:**
- TRID: Trace ID (A)
- DSPER: Display Period (U1, U2, U4)
- TOTSMP: Total Samples (U1, U2, U4)
- REPGSZ: Report Page Size (U1, U2, U4)
- SVID: Status Variable ID (U1, U2, U4, or A)



### Stream 3: Material Status
**Purpose**: Material and carrier tracking

| Message | Direction | Description |
|---------|-----------|-------------|
| [S3F1](#s3f1---material-status-request)    | → Equipment | Material Status Request |
| [S3F2](#s3f2---material-status-data)    | ← Equipment | Material Status Data |
| [S3F3](#s3f3---time-to-completion-data)    | → Equipment | Time to Completion Data |
| [S3F4](#s3f4---time-to-completion-data)    | ← Equipment | Time to Completion Data |
| [S3F5](#s3f5---material-found-send)    | ← Equipment | Material Found Send |
| [S3F6](#s3f6---material-found-acknowledge)    | → Equipment | Material Found Acknowledge |
| [S3F7](#s3f7---material-lost-send)    | → Equipment | Material Lost Send |
| [S3F8](#s3f8---material-lost-ack)    | ← Equipment | Material Lost Ack |
| [S3F9](#s3f9---matl-id-equate-send)    | ← Equipment | Matl ID Equate Send |
| [S3F10](#s3f10---port-status-acknowledge)   | → Equipment | Port Status Acknowledge |
| [S3F11](#s3f11---matl-id-request)   | → Equipment | Matl ID Request |
| [S3F12](#s3f12---matl-id-request-ack)   | ← Equipment | Matl ID Request Ack |
| [S3F13](#s3f13---matl-id-send)   | ← Equipment | Matl ID Send |
| [S3F14](#s3f14---matl-id-ack)   | → Equipment | Matl ID Ack |
| [S3F15](#s3f15---matls-multi-block-inquire)   | → Equipment | SECS-I Matls Multi-block Inquire |
| [S3F16](#s3f16---matls-multi-block-grant)   | ← Equipment | Matls Multi-block Grant |
| [S3F17](#s3f17---carrier-action-request-extended)   | → Equipment | Carrier Action Request |
| [S3F18](#s3f18---carrier-action-response-extended)   | ← Equipment | Carrier Action Ack |
| [S3F19](#s3f19---port-action-request)   | → Equipment | Cancel All Carrier Out Req |
| [S3F20](#s3f20---port-action-response)   | ← Equipment | Cancel All Carrier Out Ack |
| [S3F21](#s3f21---port-group-request)   | → Equipment | Port Group Defn |
| [S3F22](#s3f22---port-group-response)   | ← Equipment | Port Group Defn Ack |
| [S3F23](#s3f23---port-group-define)   | → Equipment | Port Group Action Req |
| [S3F24](#s3f24---port-group-define-acknowledge)   | ← Equipment | Port Group Action Req |
| [S3F25](#s3f25---carrier-id-request)   | → Equipment | Carrier ID Request |
| [S3F26](#s3f26---carrier-id-response)   | ← Equipment | Carrier ID Response |
| [S3F27](#s3f27---carrier-id-send)   | → Equipment | Carrier ID Send |
| [S3F28](#s3f28---carrier-id-acknowledge)   | ← Equipment | Carrier ID Acknowledge |
| [S3F29](#s3f29---substrate-location-request)   | → Equipment | Substrate Location Request |
| [S3F30](#s3f30---substrate-location-response)   | ← Equipment | Substrate Location Response |
| [S3F31](#s3f31---substrate-location-send)   | ← Equipment | Substrate Location Send |
| [S3F32](#s3f32---substrate-location-acknowledge)   | → Equipment | Substrate Location Acknowledge |
| [S3F33](#s3f33---load-lock-status-request)   | → Equipment | Load Lock Status Request |
| [S3F34](#s3f34---load-lock-status-response)   | ← Equipment | Load Lock Status Response |
| [S3F35](#s3f35---load-lock-status-send)   | ← Equipment | Load Lock Status Send |
| [S3F36](#s3f36---load-lock-status-acknowledge)   | → Equipment | Load Lock Status Acknowledge |

#### **S3F1 - Material Status Request** {#s3f1---material-status-request}
```
{}
``` 

#### **S3F2 - Material Status Data** {#s3f2---material-status-data}
```
{L[2]
  MF
  {L[n]
    {L[3]
      LOC
      QUA
      MID
    }
  }
}
``` 

#### **S3F3 - Time to Completion Data** {#s3f3---time-to-completion-data}
```
{}
``` 

#### **S3F4 - Time to Completion Data** {#s3f4---time-to-completion-data}
```
{L[2]
  MF
  {L[n]
    {L[3]
      TTC
      QUA
      MID
    }
  }
}

``` 

#### **S3F5 - Material Found Send** {#s3f5---material-found-send}
``` 
{L[2]
  MF
  QUA
}

``` 

#### **S3F6 - Material Found Acknowledge** {#s3f6---material-found-acknowledge}
```
ACKC3
```
```
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F7 - Material Lost Send** {#s3f7---material-lost-send}
```
{L[3]
  MF
  QUA
  MID
}

``` 

#### **S3F8 - Material Lost Ack** {#s3f8---material-lost-ack}

```
ACKC3
``` 

```
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F9 - Matl ID Equate Send** {#s3f9---matl-id-equate-send}
```

{L[2]
  MID
  EMID
}


``` 

#### **S3F10 - Port Status Acknowledge** {#s3f10---port-status-acknowledge}
```

ACKC3

```
```

- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F11 - Matl ID Request** {#s3f11---matl-id-request}
```
{
  PTN
}
```

#### **S3F12 - Matl ID Request Ack** {#s3f12---matl-id-request-ack}
```
{L[3]
  PTN
  MIDRA
  MID
} 
```
 

#### **S3F13 - Matl ID Send** {#s3f13---matl-id-send}
```
{L[2]
  PTN
  MID
}
``` 

#### **S3F14 - Matl ID Ack** {#s3f14---matl-id-ack}
```
{
  MIDAC
}

```
 
#### **S3F15 - Matls Multi-block Inquire(SECS-I)** {#s3f15---matls-multi-block-inquire}
```
{L[2]
  DATAID
  DATALENGTH
}
``` 

#### **S3F16 - Matls Multi-block Grant** {#s3f16---matls-multi-block-grant}
```
{
  GRANT
}

``` 
#### **S3F17 - Carrier Action Request (Extended)** {#s3f17---carrier-action-request-extended}
```

{L[5]
  DATAID
  CARRIERACTION
  CARRIERID
  PTN
  {L[n]
    {L[2]
      CATTRID
      CATTRDATA
    }
  }
}

```
```

- DATAID: Data ID (U1, U2, U4, or A)
- CARRIERACTION: Carrier Action (U1)
- CARRIERID: Carrier ID (A)
- PTN: Port Number (U1)
- CATTRID: Carrier Attribute ID (U1, U2, U4, or A)
- CATTRDATA: Carrier Attribute Data (any format)
```

#### **S3F18 - Carrier Action Response (Extended)** {#s3f18---carrier-action-response-extended}
```

{L[2]
  DATAID
  CAACK
}

```
```

- DATAID: Data ID (matching request)
- CAACK: Carrier Action Acknowledge (U1)
  - 0: Acknowledged
  - 1: Denied, Invalid Command
  - 2: Denied, Cannot Perform Now
```

#### **S3F19 - Port Action Request** {#s3f19---port-action-request}
```

{L[4]
  DATAID
  PORTACTION
  PTN
  {L[n]
    {L[2]
      PATTRID
      PATTRDATA
    }
  }
}

```
```

- DATAID: Data ID (U1, U2, U4, or A)
- PORTACTION: Port Action (U1)
  - 1: Open
  - 2: Close
  - 3: Lock
  - 4: Unlock
- PTN: Port Number (U1)
- PATTRID: Port Attribute ID (U1, U2, U4, or A)
- PATTRDATA: Port Attribute Data (any format)
```

#### **S3F20 - Cancel All Carrier Out Ack** {#s3f20---cancel-all-carrier-out-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
``` 

#### **S3F21 - Port Group Defn** {#s3f21---port-group-defn}
```
{L[3]
  PORTGRPNAME
  ACCESSMODE
  {L[n]
    PTN
  }
}
```
 

#### **S3F22 - Port Group Defn Ack** {#s3f22---port-group-defn-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[2]
    ERRCODE
    ERRTEXT
    }
  }
}
``` 

#### **S3F23 - Port Group Action Req** {#s3f23---port-group-action-req}
```
{L[3]
  PGRPACTION
  PORTGRPNAME
  {L[m]
    {L[2]
      PARAMNAME
      PARAMVAL
    }
  }
}

``` 

#### **S3F24 - Port Group Action Ack** {#s3f24---port-group-action-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
``` 

#### **S3F25 - Port Action Req** {#s3f25---port-action-req}

```
{L[3]
  PORTACTION
  PTN
  {L[m]
    {L[2]
      PARAMNAME
      PARAMVAL
    }
  }
}
``` 

#### **S3F26 - Port Action Ack** {#s3f26---port-action-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[2]
    ERRCODE
    ERRTEXT
    }
  }
}
``` 

#### **S3F27 - Change Access** {#s3f27---change-access}
```
{L[2]
  ACCESSMODE
  {L[n]
  PTN
  }
} 
``` 

#### **S3F28 - Change Access Ack** {#s3f28---change-access-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[3]
      PTN
      ERRCODE
      ERRTEXT
    }
  }
}

``` 

#### **S3F29 - Carrier Tag Read Req** {#s3f29---carrier-tag-read-req}
```
{L[4]
  LOCID
  CARRIERSPEC
  DATASEG
  DATALENGTH
}
``` 
#### **S3F30 - Carrier Tag Read Data** {#s3f30---carrier-tag-read-data}
```
{L[2]
  DATA
  {L[2]
    CAACK
    {L[n]
      {L[2]
      ERRCODE
      ERRTEXT
      }
    }
  }
}

``` 
#### **S3F31 - Carrier Tag Write Data** {#s3f31---carrier-tag-write-data}
```

{L[5]
  LOCID
  CARRIERSPEC
  DATASEG
  DATALENGTH
  DATA
}

``` 

#### **S3F32 - Carrier Tag Write Ack** {#s3f32---carrier-tag-write-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
} 
``` 

#### **S3F33 - Cancel All Pod Out Req** {#s3f33---cancel-all-pod-out-req}
```
{}

``` 

#### **S3F34 - Cancel All Pod Out Ack** {#s3f34---cancel-all-pod-out-ack}
```
{L[2]
  CAACK
  {L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
``` 

#### **S3F35 - Reticle Transfer Job Req** {#s3f35---reticle-transfer-job-req}
```
{L[7]
  JOBACTION
  PODID
  INPTN
  OUTPTN
  {L[n]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[m]
    {L[3]
      RETICLEID
      RETREMOVEINSTR
      {L[i]
        {L[2]
          ATTRID
          ATTRDATA
        }
      }
    }
  }
  {L[k]
    {L[2]
      RETICLEID2
      RETPLACEINSTR
    }
  }
}
``` 

#### **S3F36 - Reticle Transfer Job Ack** {#s3f36---reticle-transfer-job-ack}
```
{L[2]
  RPMACK
  {L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
} 
``` 

### Stream 4: Material Control
**Purpose**: Material transfer and handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S4F1](#s4f1---ready-to-send-materials)    | → Equipment | Ready to Send Materials |
| [S4F2](#s4f2---ready-to-send-acknowledge)    | ← Equipment | Ready to Send Acknowledge |
| [S4F3](#s4f3---send-material)    | → Equipment | Send Material |
| [S4F4](#s4f4---transfer-job-cancel-acknowledge)    | ← Equipment | Transfer Job Cancel Acknowledge |
| [S4F5](#s4f5---transfer-job-start)    | → Equipment | Transfer Job Start |
| [S4F6](#s4f6---transfer-job-start-acknowledge)    | ← Equipment | Transfer Job Start Acknowledge |
| [S4F7](#s4f7---transfer-job-pause)    | → Equipment | Transfer Job Pause |
| [S4F8](#s4f8---transfer-job-pause-acknowledge)    | ← Equipment | Transfer Job Pause Acknowledge |
| [S4F9](#s4f9---transfer-job-stop)    | → Equipment | Transfer Job Stop |
| [S4F10](#s4f10---transfer-job-stop-acknowledge)   | ← Equipment | Transfer Job Stop Acknowledge |
| [S4F11](#s4f11---transfer-job-abort)   | → Equipment | Transfer Job Abort |
| [S4F12](#s4f12---transfer-job-abort-acknowledge)   | ← Equipment | Transfer Job Abort Acknowledge |
| [S4F13](#s4f13---transfer-job-resume)   | → Equipment | Transfer Job Resume |
| [S4F14](#s4f14---transfer-job-resume-acknowledge)   | ← Equipment | Transfer Job Resume Acknowledge |
| [S4F15](#s4f15---transfer-job-status-request)   | → Equipment | Transfer Job Status Request |
| [S4F16](#s4f16---transfer-job-status-response)   | ← Equipment | Transfer Job Status Response |
| [S4F17](#s4f17---transfer-job-priority-update)   | → Equipment | Transfer Job Priority Update |
| [S4F18](#s4f18---transfer-job-priority-acknowledge)   | ← Equipment | Transfer Job Priority Acknowledge |
| [S4F19](#s4f19---transfer-command)   | → Equipment | Transfer Command |
| [S4F20](#s4f20---transfer-command-acknowledge)   | ← Equipment | Transfer Command Acknowledge |
| [S4F21](#s4f21---enhanced-transfer-command)   | → Equipment | Enhanced Transfer Command |
| [S4F22](#s4f22---enhanced-transfer-acknowledge)   | ← Equipment | Enhanced Transfer Acknowledge |
| [S4F23](#s4f23---transfer-status-send)   | ← Equipment | Transfer Status Send |
| [S4F24](#s4f24---transfer-status-acknowledge)   | → Equipment | Transfer Status Acknowledge |
| [S4F25](#s4f25---material-status-request)   | → Equipment | Material Status Request |
| [S4F26](#s4f26---material-status-response)   | ← Equipment | Material Status Response |
#### **S4F1 - Ready to Send Materials** {#s4f1---ready-to-send-materials}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F2 - Ready to Send Acknowledge** {#s4f2---ready-to-send-acknowledge}
```
RSACK
```

**Parameters:**
- RSACK: Ready to Send Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Not ready

#### **S4F3 - Send Material** {#s4f3---send-material}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F5 - Handshake Complete** {#s4f5---handshake-complete}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F7 - Not Ready to Send** {#s4f7---not-ready-to-send}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F9 - Stuck in Sender** {#s4f9---stuck-in-sender}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F11 - Stuck in Receiver** {#s4f11---stuck-in-receiver}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F13 - Send Incomplete Timeout** {#s4f13---send-incomplete-timeout}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F15 - Material Received** {#s4f15---material-received}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F17 - Request to Receive** {#s4f17---request-to-receive}
```
{L[2]
  PTN
  MID
}
```

**Parameters:**
- PTN: Port Number (U1)
- MID: Material ID (A)

#### **S4F18 - Request to Receive Acknowledge** {#s4f18---request-to-receive-acknowledge}
```
RRACK
```

**Parameters:**
- RRACK: Request to Receive Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Not ready

#### **S4F19 - Transfer Job Create** {#s4f19---transfer-job-create}
```
{L[3]
  DATAID
  TRJOBNAME
  {L[n]
    {L[12]
      TRLINK
      TRPORT
      TROBJNAME
      TROBJTYPE
      TRROLE
      TRRCP
      TRPTNR
      TRPTPORT
      TRDIR
      TRTYPE
      TRLOCATION
      TRAUTOSTART
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- TRJOBNAME: Transfer Job Name (A)
- TRLINK: Transfer Link (U1)
- TRPORT: Transfer Port (U1)
- TROBJNAME: Transfer Object Name (A)
- TROBJTYPE: Transfer Object Type (A)
- TRROLE: Transfer Role (A)
- TRRCP: Transfer RCP (A)
- TRPTNR: Transfer Partner (A)
- TRPTPORT: Transfer Partner Port (U1)
- TRDIR: Transfer Direction (A)
- TRTYPE: Transfer Type (A)
- TRLOCATION: Transfer Location (A)
- TRAUTOSTART: Transfer Auto Start (B[1])

#### **S4F20 - Transfer Job Acknowledge** {#s4f20---transfer-job-acknowledge}
```
{L[3]
  TRJOBID
  {L[m]
    TRATOMCID
  }
{L[2]
    TRACK
    {L[n]
{L[2]
        ERRCODE
        ERRTEXT
      }
}
  }
}
```

**Parameters:**
- TRJOBID: Transfer Job ID (A)
- TRATOMCID: Transfer Atomic ID (A)
- TRACK: Transfer Acknowledge (B[1])
- ERRCODE: Error Code (U1)
- ERRTEXT: Error Text (A)

#### **S4F21 - Transfer Job Command** {#s4f21---transfer-job-command}
```
{L[3]
  TRJOBID
  TRCMDNAME
  {L[n]
{L[2]
      CPNAME
      CPVAL
    }
}
}
```

**Parameters:**
- TRJOBID: Transfer Job ID (A)
- TRCMDNAME: Transfer Command Name (A)
- CPNAME: Command Parameter Name (A)
- CPVAL: Command Parameter Value (any format)

#### **S4F22 - Transfer Job Command Acknowledge** {#s4f22---transfer-job-command-acknowledge}
```
{L[2]
  TRACK
{L[n]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- TRACK: Transfer Acknowledge (B[1])
- ERRCODE: Error Code (U1)
- ERRTEXT: Error Text (A)

#### **S4F23 - Transfer Command Alert** {#s4f23---transfer-command-alert}
```
{L[4]
  TRJOBID
  TRJOBNAME
  TRJOBMS
  {L[2]
    TRACK
{L[n]
      {L[2]
        ERRCODE
        ERRTEXT
      }
  }
}
}
```

**Parameters:**
- TRJOBID: Transfer Job ID (A)
- TRJOBNAME: Transfer Job Name (A)
- TRJOBMS: Transfer Job Message (A)
- TRACK: Transfer Acknowledge (B[1])
- ERRCODE: Error Code (U1)
- ERRTEXT: Error Text (A)

#### **S4F24 - Transfer Alert Acknowledge** {#s4f24---transfer-alert-acknowledge}
```
header only
```

**Parameters:**
- Header only message

#### **S4F25 - Multi-block Inquire** {#s4f25---multi-block-inquire}
```
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- DATALENGTH: Data Length (U4)

#### **S4F26 - Multi-block Grant** {#s4f26---multi-block-grant}
```
GRANT
```

**Parameters:**
- GRANT: Grant signal (B[1])
  - 0: Not granted
  - 1: Granted

#### **S4F27 - Handoff Ready** {#s4f27---handoff-ready}
```
{L[2]
  EQNAME
  {L[11]
    TRLINK
    TRPORT
    TROBJNAME
    TROBJTYPE
    TRROLE
    TRPTNR
    TRPTPORT
    TRDIR
    TRTYPE
    TRLOCATION
  }
}
```

**Parameters:**
- EQNAME: Equipment Name (A)
- TRLINK: Transfer Link (U1)
- TRPORT: Transfer Port (U1)
- TROBJNAME: Transfer Object Name (A)
- TROBJTYPE: Transfer Object Type (A)
- TRROLE: Transfer Role (A)
- TRPTNR: Transfer Partner (A)
- TRPTPORT: Transfer Partner Port (U1)
- TRDIR: Transfer Direction (A)
- TRTYPE: Transfer Type (A)
- TRLOCATION: Transfer Location (A)

#### **S4F29 - Handoff Command** {#s4f29---handoff-command}
```
{L[4]
  TRLINK
  MCINDEX
  HOCMDNAME
  {L[n]
    {L[2]
      CPNAME
      CPVAL
    }
  }
}
```

**Parameters:**
- TRLINK: Transfer Link (U1)
- MCINDEX: Machine Control Index (U1)
- HOCMDNAME: Handoff Command Name (A)
- CPNAME: Command Parameter Name (A)
- CPVAL: Command Parameter Value (any format)

#### **S4F31 - Handoff Command Complete** {#s4f31---handoff-command-complete}
```
{L[3]
  TRLINK
  MCINDEX
{L[2]
    HOACK
    {L[n]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- TRLINK: Transfer Link (U1)
- MCINDEX: Machine Control Index (U1)
- HOACK: Handoff Acknowledge (B[1])
- ERRCODE: Error Code (U1)
- ERRTEXT: Error Text (A)

#### **S4F33 - Handoff Verified** {#s4f33---handoff-verified}
```
    {L[2]
  TRLINK
  {L[2]
    HOACK
    {L[n]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- TRLINK: Transfer Link (U1)
- HOACK: Handoff Acknowledge (B[1])
- ERRCODE: Error Code (U1)
- ERRTEXT: Error Text (A)

#### **S4F35 - Handoff Cancel Ready** {#s4f35---handoff-cancel-ready}
```
TRLINK
```

**Parameters:**
- TRLINK: Transfer Link (U1)

#### **S4F37 - Handoff Cancel Ready Acknowledge** {#s4f37---handoff-cancel-ready-acknowledge}
```
{L[2]
  TRLINK
  HOCANCELACK
}
```

**Parameters:**
- TRLINK: Transfer Link (U1)
- HOCANCELACK: Handoff Cancel Acknowledge (B[1])

#### **S4F39 - Handoff Halt** {#s4f39---handoff-halt}
```
TRLINK
```

**Parameters:**
- TRLINK: Transfer Link (U1)

#### **S4F41 - Handoff Halt Acknowledge** {#s4f41---handoff-halt-acknowledge}
```
      {L[2]
  TRLINK
  HOHALTACK
}
```

**Parameters:**
- TRLINK: Transfer Link (U1)
- HOHALTACK: Handoff Halt Acknowledge (B[1])


### Stream 5: Exception Reporting
**Purpose**: Alarm and exception handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S5F1](#s5f1---alarm-report-send)    | ← Equipment | Alarm Report Send |
| [S5F2](#s5f2---alarm-report-acknowledge)    | → Equipment | Alarm Report Acknowledge |
| [S5F3](#s5f3---enabledisable-alarm-send)    | → Equipment | En/Disable Alarm Send |
| [S5F4](#s5f4---enabledisable-alarm-acknowledge)    | ← Equipment | En/Disable Alarm Acknowledge |
| [S5F5](#s5f5---list-alarms-request)    | → Equipment | List Alarms Request |
| [S5F6](#s5f6---list-alarms-response)    | ← Equipment | List Alarms Response |
| [S5F7](#s5f7---list-enabled-alarm-request)    | → Equipment | List Enabled Alarm Request |
| [S5F8](#s5f8---list-enabled-alarm-response)    | ← Equipment | List Enabled Alarm Response |

#### **S5F1 - Alarm Report Send** {#s5f1---alarm-report-send}
```

{L[3]
  ALCD
  ALID
  ALTX
}

```
```

- ALCD: Alarm Code (B[1])
  - Bit 0: Alarm Set (1) or Clear (0)
  - Bit 7: Alarm (1) or Warning (0)
- ALID: Alarm ID (U1, U2, U4, or A)
- ALTX: Alarm Text (A[120])
```

#### **S5F2 - Alarm Report Acknowledge** {#s5f2---alarm-report-acknowledge}
```

ACKC5

```
```

- ACKC5: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S5F3 - Enable/Disable Alarm Send** {#s5f3---enabledisable-alarm-send}
```

{L[2]
  ALED
  {L[n]
    ALID_1
    ALID_2
    ...
    ALID_n
  }
}

```
```

- ALED: Alarm Enable/Disable (B[1])
  - 128 (0x80): Enable
  - 0: Disable
- ALID: Alarm ID (U1, U2, U4, or A)
```

#### **S5F4 - Enable/Disable Alarm Acknowledge** {#s5f4---enabledisable-alarm-acknowledge}
```

ACKC5

```
```

- ACKC5: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S5F5 - List Alarms Request** {#s5f5---list-alarms-request}
```
{}
```

#### **S5F6 - List Alarms Response** {#s5f6---list-alarms-response}
```

{L[n]
  ALID_1
  ALID_2
  ...
  ALID_n
}

```
```

- ALID: Alarm ID (U1, U2, U4, or A)
```

#### **S5F7 - List Enabled Alarm Request** {#s5f7---list-enabled-alarm-request}
```
{}
```

#### **S5F8 - List Enabled Alarm Response** {#s5f8---list-enabled-alarm-response}
```

{L[n]
  ALID_1
  ALID_2
  ...
  ALID_n
}

```
```

- ALID: Alarm ID (U1, U2, U4, or A) - Only enabled alarms
```

### Stream 6: Data Collection
**Purpose**: Process data collection and event reporting

| Message | Direction | Description |
|---------|-----------|-------------|
| [S6F1](#s6f1---trace-data-send)    | ← Equipment | Trace Data Send |
| [S6F2](#s6f2---trace-data-acknowledge)    | → Equipment | Trace Data Acknowledge |
| [S6F3](#s6f3---discrete-variable-data-send)    | ← Equipment | Discrete Variable Data Send |
| [S6F4](#s6f4---discrete-variable-data-acknowledge)    | → Equipment | Discrete Variable Data Acknowledge |
| [S6F5](#s6f5---multi-block-data-send-inquire)    | ← Equipment | Multi-block Data Send Inquire |
| [S6F6](#s6f6---multi-block-grant)    | → Equipment | Multi-block Grant |
| [S6F7](#s6f7---data-transfer-request)    | → Equipment | Data Transfer Request |
| [S6F8](#s6f8---data-transfer-data)    | ← Equipment | Data Transfer Data |
| [S6F9](#s6f9---formatted-variable-send)    | ← Equipment | Formatted Variable Send |
| [S6F10](#s6f10---formatted-variable-acknowledge)    | → Equipment | Formatted Variable Acknowledge |
| [S6F11](#s6f11---event-report-send)   | ← Equipment | Event Report Send |
| [S6F12](#s6f12---event-report-acknowledge)   | → Equipment | Event Report Acknowledge |
| [S6F13](#s6f13---annotated-event-report-send)   | ← Equipment | Annotated Event Report Send |
| [S6F14](#s6f14---annotated-event-report-acknowledge)   | → Equipment | Annotated Event Report Acknowledge |
| [S6F15](#s6f15---event-report-request)   | → Equipment | Event Report Request |
| [S6F16](#s6f16---event-report-data)   | ← Equipment | Event Report Data |
| [S6F17](#s6f17---annotated-event-report-request)   | → Equipment | Annotated Event Report Request |
| [S6F18](#s6f18---annotated-event-report-data)   | ← Equipment | Annotated Event Report Data |
| [S6F19](#s6f19---individual-report-request)   | → Equipment | Individual Report Request |
| [S6F20](#s6f20---individual-report-data)   | ← Equipment | Individual Report Data |
| [S6F21](#s6f21---annotated-individual-report-request)   | → Equipment | Annotated Individual Report Request |
| [S6F22](#s6f22---annotated-individual-report-data)   | ← Equipment | Annotated Individual Report Data |
| [S6F23](#s6f23---request-or-purge-spooled-data)   | → Equipment | Request or Purge Spooled Data |
| [S6F24](#s6f24---request-or-purge-spooled-data-acknowledge)   | ← Equipment | Request or Purge Spooled Data Acknowledge |
| [S6F25](#s6f25---notification-report-send)   | ↔ Host/Equipment | Notification Report Send |
| [S6F26](#s6f26---notification-report-acknowledge)   | ↔ Host/Equipment | Notification Report Acknowledge |
| [S6F27](#s6f27---trace-report-send)   | ← Equipment | Trace Report Send |
| [S6F28](#s6f28---trace-report-acknowledge)   | → Equipment | Trace Report Acknowledge |
| [S6F29](#s6f29---trace-report-request)   | → Equipment | Trace Report Request |
| [S6F30](#s6f30---trace-report-data)   | ← Equipment | Trace Report Data |

#### **S6F1 - Trace Data Send** {#s6f1---trace-data-send}
```
{L[4]
  TRID
  SMPLN
  STIME
  {L[n]
    SV
  }
}
```

**Parameters:**
- TRID: Trace Request ID (U1, U2, U4, or A)
- SMPLN: Sample Number (U1, U2, U4)
- STIME: Sample Time (A)
- SV: Sample Value (any format)

#### **S6F2 - Trace Data Acknowledge** {#s6f2---trace-data-acknowledge}
```
ACKC6
```

**Parameters:**
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S6F3 - Discrete Variable Data Send** {#s6f3---discrete-variable-data-send}
```
{L[3]
  DATAID
  CEID
  {L[n]
    {L[2]
      DSID
      {L[m]
        {L[2]
          DVNAME
          DVVAL
      }
    }
  }
}
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- DSID: Data Set ID (U1, U2, U4, or A)
- DVNAME: Discrete Variable Name (A)
- DVVAL: Discrete Variable Value (any format)

#### **S6F4 - Discrete Variable Data Acknowledge** {#s6f4---discrete-variable-data-acknowledge}
```
ACKC6
```

**Parameters:**
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S6F5 - Multi-block Data Send Inquire** {#s6f5---multi-block-data-send-inquire}
```
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- DATALENGTH: Data Length (U4)

#### **S6F6 - Multi-block Grant** {#s6f6---multi-block-grant}
```
GRANT6
```

**Parameters:**
- GRANT6: Grant Code (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space

#### **S6F7 - Data Transfer Request** {#s6f7---data-transfer-request}
```
DATAID
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)

#### **S6F8 - Data Transfer Data** {#s6f8---data-transfer-data}
```
{L[3]
  DATAID
  CEID
  {L[n]
    DSID
      {L[m]
      {L[2]
        DVNAME
        DVVAL
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- DSID: Data Set ID (U1, U2, U4, or A)
- DVNAME: Discrete Variable Name (A)
- DVVAL: Discrete Variable Value (any format)

#### **S6F9 - Formatted Variable Send** {#s6f9---formatted-variable-send}
```
{L[4]
  PFCD
  DATAID
  CEID
  {L[n]
    {L[2]
      DSID
      {L[m]
        DVVAL
  }
}
  }
}
```

**Parameters:**
- PFCD: Process Function Code (A)
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- DSID: Data Set ID (U1, U2, U4, or A)
- DVVAL: Discrete Variable Value (any format)

#### **S6F10 - Formatted Variable Acknowledge** {#s6f10---formatted-variable-acknowledge}
```
ACKC6
```

**Parameters:**
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S6F11 - Event Report Send** {#s6f11---event-report-send}
```
{L[3]
  DATAID
  CEID
  {L[a]
{L[2]
      RPTID
      {L[b]
        V
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- V: Variable Value (any format)

#### **S6F12 - Event Report Acknowledge** {#s6f12---event-report-acknowledge}
```
ACKC6
```

**Parameters:**
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S6F13 - Annotated Event Report Send** {#s6f13---annotated-event-report-send}
```
{L[3]
  DATAID
  CEID
  {L[a]
    {L[2]
      RPTID
      {L[b]
        {L[2]
          VID
          V
  }
}
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)
- V: Variable Value (any format)

#### **S6F14 - Annotated Event Report Acknowledge** {#s6f14---annotated-event-report-acknowledge}
```
ACKC6
```

**Parameters:**
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S6F15 - Event Report Request** {#s6f15---event-report-request}
```
CEID
```

**Parameters:**
- CEID: Collection Event ID (U1, U2, U4, or A)

#### **S6F16 - Event Report Data** {#s6f16---event-report-data}
```
{L[3]
  DATAID
  CEID
  {L[a]
{L[2]
      RPTID
      {L[b]
        V
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- V: Variable Value (any format)

#### **S6F17 - Annotated Event Report Request** {#s6f17---annotated-event-report-request}
```
CEID
```

**Parameters:**
- CEID: Collection Event ID (U1, U2, U4, or A)

#### **S6F18 - Annotated Event Report Data** {#s6f18---annotated-event-report-data}
```
{L[3]
  DATAID
  CEID
  {L[a]
    {L[2]
      RPTID
      {L[b]
        {L[2]
          VID
          V
        }
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)
- V: Variable Value (any format)

#### **S6F19 - Individual Report Request** {#s6f19---individual-report-request}
```
RPTID
```

**Parameters:**
- RPTID: Report ID (U1, U2, U4, or A)

#### **S6F20 - Individual Report Data** {#s6f20---individual-report-data}
```
{L[n]
  V
}
```

**Parameters:**
- V: Variable Value (any format)

#### **S6F21 - Annotated Individual Report Request** {#s6f21---annotated-individual-report-request}
```
RPTID
```

**Parameters:**
- RPTID: Report ID (U1, U2, U4, or A)

#### **S6F22 - Annotated Individual Report Data** {#s6f22---annotated-individual-report-data}
```
{L[n]
  {L[2]
    VID
    V
  }
}
```

**Parameters:**
- VID: Variable ID (U1, U2, U4, or A)
- V: Variable Value (any format)

#### **S6F23 - Request or Purge Spooled Data** {#s6f23---request-or-purge-spooled-data}
```
RSDC
```

**Parameters:**
- RSDC: Request or Purge Spooled Data Command (A)

#### **S6F24 - Request or Purge Spooled Data Acknowledge** {#s6f24---request-or-purge-spooled-data-acknowledge}
```
RSDA
```

**Parameters:**
- RSDA: Request or Purge Spooled Data Acknowledge (A)

#### **S6F25 - Notification Report Send** {#s6f25---notification-report-send}
```
{L[7]
  DATAID
  OPID
  LINKID
  RCPSPEC
  RMCHGSTAT
  {L[m]
    {L[2]
      RCPATTRID
      RCPATTRDATA
    }
  }
  {L[2]
    RMACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
  }
}
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OPID: Operator ID (A)
- LINKID: Link ID (A)
- RCPSPEC: Recipe Specification (A)
- RMCHGSTAT: Recipe Change Status (A)
- RCPATTRID: Recipe Attribute ID (A)
- RCPATTRDATA: Recipe Attribute Data (any format)
- RMACK: Recipe Acknowledge (B[1])
- ERRCODE: Error Code (U1)
- ERRTEXT: Error Text (A)

#### **S6F26 - Notification Report Acknowledge** {#s6f26---notification-report-acknowledge}
```
ACKC6
```

**Parameters:**
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S6F27 - Trace Report Send** {#s6f27---trace-report-send}
```
{L[3]
  DATAID
  TRID
  {L[n]
    {L[p]
{L[2]
        RPTID
        {L[m]
          V
        }
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- TRID: Trace Request ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- V: Variable Value (any format)

#### **S6F28 - Trace Report Acknowledge** {#s6f28---trace-report-acknowledge}
```
TRID
```

**Parameters:**
- TRID: Trace Request ID (U1, U2, U4, or A)

#### **S6F29 - Trace Report Request** {#s6f29---trace-report-request}
```
TRID
```

**Parameters:**
- TRID: Trace Request ID (U1, U2, U4, or A)

#### **S6F30 - Trace Report Data** {#s6f30---trace-report-data}
```
  {L[3]
  TRID
  {L[n]
    {L[2]
      RPTID
      {L[m]
        V
      }
  }
}
  ERRCODE
}
```

**Parameters:**
- TRID: Trace Request ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- V: Variable Value (any format)
- ERRCODE: Error Code (A)



### Stream 7: Process Program Management
**Purpose**: Recipe and process program handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S7F1](#s7f1---process-program-load-inquire)    | ↔ Host/Equipment | Process Program Load Inquire |
| [S7F2](#s7f2---process-program-load-grant)    | ↔ Host/Equipment | Process Program Load Grant |
| [S7F3](#s7f3---process-program-send)    | ↔ Host/Equipment | Process Program Send |
| [S7F4](#s7f4---process-program-send-acknowledge)    | ↔ Host/Equipment | Process Program Send Acknowledge |
| [S7F5](#s7f5---process-program-request)    | ↔ Host/Equipment | Process Program Request |
| [S7F6](#s7f6---process-program-data)    | ↔ Host/Equipment | Process Program Data |
| [S7F7](#s7f7---process-program-id-request)    | ← Equipment | Process Program ID Request |
| [S7F8](#s7f8---process-program-id-data)    | → Host | Process Program ID Data |
| [S7F9](#s7f9---material-process-matrix-request)    | ↔ Host/Equipment | Material/Process Matrix Request |
| [S7F10](#s7f10---material-process-matrix-data)    | ↔ Host/Equipment | Material/Process Matrix Data |
| [S7F11](#s7f11---material-process-matrix-update-send)    | → Host | Material/Process Matrix Update Send |
| [S7F12](#s7f12---material-process-matrix-update-acknowledge)    | ← Equipment | Material/Process Matrix Update Acknowledge |
| [S7F13](#s7f13---material-process-matrix-delete-entry-send)    | → Host | Material/Process Matrix Delete Entry Send |
| [S7F14](#s7f14---delete-material-process-matrix-entry-acknowledge)    | ← Equipment | Delete Material/Process Matrix Entry Acknowledge |
| [S7F15](#s7f15---matrix-mode-select-send)    | → Host | Matrix Mode Select Send |
| [S7F16](#s7f16---matrix-mode-select-acknowledge)    | ← Equipment | Matrix Mode Select Acknowledge |
| [S7F17](#s7f17---delete-process-program-send)    | → Host | Delete Process Program Send |
| [S7F18](#s7f18---delete-process-program-acknowledge)    | ← Equipment | Delete Process Program Acknowledge |
| [S7F19](#s7f19---current-process-program-directory-request)    | → Host | Current Process Program Directory Request |
| [S7F20](#s7f20---current-process-program-data)    | ← Equipment | Current Process Program Data |
| [S7F21](#s7f21---process-capabilities-request)    | → Host | Process Capabilities Request |
| [S7F22](#s7f22---process-capabilities-data)    | ← Equipment | Process Capabilities Data |
| [S7F23](#s7f23---formatted-process-program-send)    | ↔ Host/Equipment | Formatted Process Program Send |
| [S7F24](#s7f24---formatted-process-program-acknowledge)    | ↔ Host/Equipment | Formatted Process Program Acknowledge |
| [S7F25](#s7f25---formatted-process-program-request)    | ↔ Host/Equipment | Formatted Process Program Request |
| [S7F26](#s7f26---formatted-process-program-data)    | ↔ Host/Equipment | Formatted Process Program Data |
| [S7F27](#s7f27---process-program-verification-send)    | ← Equipment | Process Program Verification Send |
| [S7F28](#s7f28---process-program-verification-acknowledge)    | → Host | Process Program Verification Acknowledge |
| [S7F29](#s7f29---process-program-verification-inquire)    | ← Equipment | Process Program Verification Inquire |
| [S7F30](#s7f30---process-program-verification-grant)    | → Host | Process Program Verification Grant |
| [S7F31](#s7f31---verification-request-send)    | → Host | Verification Request Send |
| [S7F32](#s7f32---verification-request-acknowledge)    | ← Equipment | Verification Request Acknowledge |
| [S7F33](#s7f33---process-program-available-request)    | ↔ Host/Equipment | Process Program Available Request |
| [S7F34](#s7f34---process-program-availability-data)    | ↔ Host/Equipment | Process Program Availability Data |
| [S7F35](#s7f35---process-program-for-mid-request)    | ↔ Host/Equipment | Process Program for MID Request |
| [S7F36](#s7f36---process-program-for-mid-data)    | ↔ Host/Equipment | Process Program for MID Data |
| [S7F37](#s7f37---large-process-program-send)    | ↔ Host/Equipment | Large Process Program Send |
| [S7F38](#s7f38---large-process-program-send-acknowledge)    | ↔ Host/Equipment | Large Process Program Send Acknowledge |
| [S7F39](#s7f39---large-formatted-process-program-send)    | ↔ Host/Equipment | Large Formatted Process Program Send |
| [S7F40](#s7f40---large-formatted-process-program-acknowledge)    | ↔ Host/Equipment | Large Formatted Process Program Acknowledge |
| [S7F41](#s7f41---large-process-program-request)    | ↔ Host/Equipment | Large Process Program Request |
| [S7F42](#s7f42---large-process-program-request-acknowledge)    | ↔ Host/Equipment | Large Process Program Request Acknowledge |
| [S7F43](#s7f43---large-formatted-process-program-request)    | ↔ Host/Equipment | Large Formatted Process Program Request |
| [S7F44](#s7f44---large-formatted-process-program-request-acknowledge)    | ↔ Host/Equipment | Large Formatted Process Program Request Acknowledge |
#### **S7F1 - Process Program Load Inquire** {#s7f1---process-program-load-inquire}
```
{L[2]
  PPID
  LENGTH
}
```

**Parameters:**
- PPID: Process Program ID (A)
- LENGTH: Length of Process Program (U1, U2, U4)

#### **S7F2 - Process Program Load Grant** {#s7f2---process-program-load-grant}
```
PPGNT
```

**Parameters:**
- PPGNT: Process Program Grant (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space
  - 3: Invalid PPID

#### **S7F3 - Process Program Send** {#s7f3---process-program-send}
```
{L[2]
  PPID
  PPBODY
}
```

**Parameters:**
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)

#### **S7F4 - Process Program Send Acknowledge** {#s7f4---process-program-send-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F5 - Process Program Request** {#s7f5---process-program-request}
```
PPID
```

**Parameters:**
- PPID: Process Program ID (A)

#### **S7F6 - Process Program Data** {#s7f6---process-program-data}
```
{L[2]
  PPID
  PPBODY
}
```

**Parameters:**
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)

#### **S7F7 - Process Program ID Request** {#s7f7---process-program-id-request}
```
MID
```

**Parameters:**
- MID: Material ID (A)

#### **S7F8 - Process Program ID Data** {#s7f8---process-program-id-data}
```
{L[2]
  PPID
  MID
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MID: Material ID (A)

#### **S7F9 - Material/Process Matrix Request** {#s7f9---material-process-matrix-request}
```
header only
```

**Parameters:**
- Header only message

#### **S7F10 - Material/Process Matrix Data** {#s7f10---material-process-matrix-data}
```
{L[n]
  {L[2]
    PPID
    {L[a]
      MID
  }
}
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MID: Material ID (A)

#### **S7F11 - Material/Process Matrix Update Send** {#s7f11---material-process-matrix-update-send}
```
{L[n]
  {L[2]
    PPID
    {L[a]
      MID
    }
  }
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MID: Material ID (A)

#### **S7F12 - Material/Process Matrix Update Acknowledge** {#s7f12---material-process-matrix-update-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F13 - Material/Process Matrix Delete Entry Send** {#s7f13---material-process-matrix-delete-entry-send}
```
{L[n]
{L[2]
  PPID
    {L[a]
      MID
}
  }
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MID: Material ID (A)

#### **S7F14 - Delete Material/Process Matrix Entry Acknowledge** {#s7f14---delete-material-process-matrix-entry-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F15 - Matrix Mode Select Send** {#s7f15---matrix-mode-select-send}
```
MMODE
```

**Parameters:**
- MMODE: Matrix Mode (A)

#### **S7F16 - Matrix Mode Select Acknowledge** {#s7f16---matrix-mode-select-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F17 - Delete Process Program Send** {#s7f17---delete-process-program-send}
```
{L[n]
  PPID
}
```

**Parameters:**
- PPID: Process Program ID (A)

#### **S7F18 - Delete Process Program Acknowledge** {#s7f18---delete-process-program-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F19 - Current Process Program Directory Request** {#s7f19---current-process-program-directory-request}
```
header only
```

**Parameters:**
- Header only message

#### **S7F20 - Current Process Program Data** {#s7f20---current-process-program-data}
```
{L[n]
    PPID
    }
```

**Parameters:**
- PPID: Process Program ID (A)

#### **S7F21 - Process Capabilities Request** {#s7f21---process-capabilities-request}
```
header only
```

**Parameters:**
- Header only message

#### **S7F22 - Process Capabilities Data** {#s7f22---process-capabilities-data}
```
{L[5]
  MDLN
  SOFTREV
  CMDMAX
  BYTMAX
  {L[c]
    {L[11]
      CCODE
      CNAME
      RQCMD
      BLKDEF
      BCDS
      IBCDS
      NBCDS
      ACDS
      IACDS
      NACDS
      {L[p]
        L[x]
      }
    }
  }
}
```

**Parameters:**
- MDLN: Model Number (A)
- SOFTREV: Software Revision (A)
- CMDMAX: Command Maximum (U1, U2, U4)
- BYTMAX: Byte Maximum (U1, U2, U4)
- CCODE: Command Code (A)
- CNAME: Command Name (A)
- RQCMD: Required Command (A)
- BLKDEF: Block Definition (A)
- BCDS: Block Code Data Set (A)
- IBCDS: Input Block Code Data Set (A)
- NBCDS: Number Block Code Data Set (A)
- ACDS: Alarm Code Data Set (A)
- IACDS: Input Alarm Code Data Set (A)
- NACDS: Number Alarm Code Data Set (A)
- L[x]: Variable length data (any format)

#### **S7F23 - Formatted Process Program Send** {#s7f23---formatted-process-program-send}
```
{L[4]
  PPID
  MDLN
  SOFTREV
  {L[c]
    {L[2]
      CCODE
      {L[p]
        PPARM
      }
    }
  }
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MDLN: Model Number (A)
- SOFTREV: Software Revision (A)
- CCODE: Command Code (A)
- PPARM: Process Program Parameter (any format)

#### **S7F24 - Formatted Process Program Acknowledge** {#s7f24---formatted-process-program-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F25 - Formatted Process Program Request** {#s7f25---formatted-process-program-request}
```
PPID
```

**Parameters:**
- PPID: Process Program ID (A)

#### **S7F26 - Formatted Process Program Data** {#s7f26---formatted-process-program-data}
```
{L[4]
  PPID
  MDLN
  SOFTREV
  {L[c]
    {L[2]
      CCODE
      {L[p]
        PPARM
      }
    }
  }
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MDLN: Model Number (A)
- SOFTREV: Software Revision (A)
- CCODE: Command Code (A)
- PPARM: Process Program Parameter (any format)

#### **S7F27 - Process Program Verification Send** {#s7f27---process-program-verification-send}
```
{L[2]
  PPID
  {L[n]
    {L[3]
      ACKC7A
      SEQNUM
      ERRW7
  }
}
}
```

**Parameters:**
- PPID: Process Program ID (A)
- ACKC7A: Acknowledge Code 7A (B[1])
- SEQNUM: Sequence Number (U1, U2, U4)
- ERRW7: Error Word 7 (A)

#### **S7F28 - Process Program Verification Acknowledge** {#s7f28---process-program-verification-acknowledge}
```
header only
```

**Parameters:**
- Header only message

#### **S7F29 - Process Program Verification Inquire** {#s7f29---process-program-verification-inquire}
```
LENGTH
```

**Parameters:**
- LENGTH: Length of S7F27 message (U4)

#### **S7F30 - Process Program Verification Grant** {#s7f30---process-program-verification-grant}
```
PPGNT
```

**Parameters:**
- PPGNT: Process Program Grant (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space
  - 3: Invalid PPID

#### **S7F31 - Verification Request Send** {#s7f31---verification-request-send}
```
{L[4]
  PPID
  MDLN
  SOFTREV
  {L[c]
    {L[2]
      CCODE
      {L[p]
        PPARM
      }
    }
  }
}
```

**Parameters:**
- PPID: Process Program ID (A)
- MDLN: Model Number (A)
- SOFTREV: Software Revision (A)
- CCODE: Command Code (A)
- PPARM: Process Program Parameter (any format)

#### **S7F32 - Verification Request Acknowledge** {#s7f32---verification-request-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F33 - Process Program Available Request** {#s7f33---process-program-available-request}
```
PPID
```

**Parameters:**
- PPID: Process Program ID (A)

#### **S7F34 - Process Program Availability Data** {#s7f34---process-program-availability-data}
```
{L[3]
  PPID
  UNFLEN
  FRMLEN
}
```

**Parameters:**
- PPID: Process Program ID (A)
- UNFLEN: Unformatted Length (U1, U2, U4)
- FRMLEN: Formatted Length (U1, U2, U4)

#### **S7F35 - Process Program for MID Request** {#s7f35---process-program-for-mid-request}
```
MID
```

**Parameters:**
- MID: Material ID (A)

#### **S7F36 - Process Program for MID Data** {#s7f36---process-program-for-mid-data}
```
{L[3]
  MID
  PPID
  PPBODY
}
```

**Parameters:**
- MID: Material ID (A)
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)

#### **S7F37 - Large Process Program Send** {#s7f37---large-process-program-send}
```
DSNAME
```

**Parameters:**
- DSNAME: Data Set Name (A)

#### **S7F38 - Large Process Program Send Acknowledge** {#s7f38---large-process-program-send-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F39 - Large Formatted Process Program Send** {#s7f39---large-formatted-process-program-send}
```
DSNAME
```

**Parameters:**
- DSNAME: Data Set Name (A)

#### **S7F40 - Large Formatted Process Program Acknowledge** {#s7f40---large-formatted-process-program-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F41 - Large Process Program Request** {#s7f41---large-process-program-request}
```
DSNAME
```

**Parameters:**
- DSNAME: Data Set Name (A)

#### **S7F42 - Large Process Program Request Acknowledge** {#s7f42---large-process-program-request-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy

#### **S7F43 - Large Formatted Process Program Request** {#s7f43---large-formatted-process-program-request}
```
DSNAME
```

**Parameters:**
- DSNAME: Data Set Name (A)

#### **S7F44 - Large Formatted Process Program Request Acknowledge** {#s7f44---large-formatted-process-program-request-acknowledge}
```
ACKC7
```

**Parameters:**
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy


### Stream 8: Control Program Management
**Purpose**: Control program and recipe management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S8F1](#s8f1---boot-program-request)    | → Equipment | Boot Program Request |
| [S8F2](#s8f2---boot-program-data)    | ← Equipment | Boot Program Data |
| [S8F3](#s8f3---executive-program-request)    | → Equipment | Executive Program Request |
| [S8F4](#s8f4---executive-program-data)    | ← Equipment | Executive Program Data |

#### **S8F1 - Boot Program Request** {#s8f1---boot-program-request}
```
{}
```

**Parameters:**
- Empty list (header only message)

#### **S8F2 - Boot Program Data** {#s8f2---boot-program-data}
```
BPD
```

**Parameters:**
- BPD: Boot Program Data (B)

#### **S8F3 - Executive Program Request** {#s8f3---executive-program-request}
```
{}
```

**Parameters:**
- Empty list (header only message)

#### **S8F4 - Executive Program Data** {#s8f4---executive-program-data}
```
EPD
```

**Parameters:**
- EPD: Executive Program Data (B)



### Stream 9: System Errors
**Purpose**: Communication error reporting

| Message | Direction | Description |
|---------|-----------|-------------|
| [S9F1](#s9f1---unrecognized-device-id)    | ← Equipment | Unrecognized Device ID |
| [S9F3](#s9f3---unrecognized-stream-type)    | ← Equipment | Unrecognized Stream Type |
| [S9F5](#s9f5---unrecognized-function-type)    | ← Equipment | Unrecognized Function Type |
| [S9F7](#s9f7---illegal-data)    | ← Equipment | Illegal Data |
| [S9F9](#s9f9---transaction-timer-timeout)    | ← Equipment | Transaction Timer Timeout |
| [S9F11](#s9f11---data-too-long)   | ← Equipment | Data Too Long |
| [S9F13](#s9f13---conversation-timeout)   | ← Equipment | Conversation Timeout |

#### **S9F1 - Unrecognized Device ID** {#s9f1---unrecognized-device-id}
```

MHEAD

```
```

- MHEAD: Message Header (B[10])
  The complete 10-byte header of the unrecognized message
```

#### **S9F3 - Unrecognized Stream Type** {#s9f3---unrecognized-stream-type}
```

MHEAD

```
```

- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message with unrecognized stream type
```

#### **S9F5 - Unrecognized Function Type** {#s9f5---unrecognized-function-type}
```

MHEAD

```
```

- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message with unrecognized function type
```

#### **S9F7 - Illegal Data** {#s9f7---illegal-data}
```

MHEAD

```
```

- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message with illegal data
```

#### **S9F9 - Transaction Timer Timeout** {#s9f9---transaction-timer-timeout}
```

MHEAD

```
```

- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message that timed out
```

#### **S9F11 - Data Too Long** {#s9f11---data-too-long}
```

MHEAD

```
```

- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message that was too long
```

#### **S9F13 - Conversation Timeout** {#s9f13---conversation-timeout}
```

{L[2]
  MEXP
  EDID
}

```
```

- MEXP: Message Expected (B[1])
  - Stream and Function of the expected message
- EDID: Equipment ID (U1, U2, U4, or A)
  - ID of the equipment that timed out
```

### Stream 10: Terminal Services
**Purpose**: Operator interface communication

| Message | Direction | Description |
|---------|-----------|-------------|
| [S10F1](#s10f1---terminal-request)   | → Equipment | Terminal Request |
| [S10F2](#s10f2---terminal-response)   | ← Equipment | Terminal Response |
| [S10F3](#s10f3---terminal-display-single)   | → Equipment | Terminal Display, Single |
| [S10F5](#s10f5---terminal-display-multi-block)   | → Equipment | Terminal Display, Multi-Block |
| [S10F7](#s10f7---multi-block-not-allowed)   | ← Equipment | Multi-block Not Allowed |
| [S10F9](#s10f9---broadcast-display-request)   | → Equipment | Broadcast Display Request |
| [S10F10](#s10f10---broadcast-display-acknowledge)  | ← Equipment | Broadcast Display Acknowledge |

#### **S10F1 - Terminal Request** {#s10f1---terminal-request}
```

{L[2]
  TID
  TEXT
}

```
```

- TID: Terminal ID (U1)
- TEXT: Text Message (A)
```

#### **S10F2 - Terminal Response** {#s10f2---terminal-response}
```

{L[2]
  TID
  ACKC10
}

```
```

- TID: Terminal ID (U1)
- ACKC10: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Terminal not available
```

#### **S10F3 - Terminal Display, Single** {#s10f3---terminal-display-single}
```

{L[2]
  TID
  TEXT
}

```
```

- TID: Terminal ID (U1)
- TEXT: Text Message (A)
```

#### **S10F5 - Terminal Display, Multi-Block** {#s10f5---terminal-display-multi-block}
```

{L[3]
  TID
  {L[n]
    TEXT_1
    TEXT_2
    ...
    TEXT_n
  }
  MHEAD
}

```
```

- TID: Terminal ID (U1)
- TEXT: Text Message (A)
- MHEAD: Message Header (B[10])
```

#### **S10F7 - Multi-block Not Allowed** {#s10f7---multi-block-not-allowed}
```
TID
```

**Parameters:**
- TID: Transaction ID (U1, U2, U4, or A)

#### **S10F9 - Broadcast Display Request** {#s10f9---broadcast-display-request}
```
TEXT
```

**Parameters:**
- TEXT: Text Message (A)

#### **S10F10 - Broadcast Display Acknowledge** {#s10f10---broadcast-display-acknowledge}
```
ACKC10
```
```
**Parameters:**
- ACKC10: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Broadcast not supported
  - 1: Error
```

### Stream 12: Wafer Mapping
**Purpose**: Wafer map data handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S12F1](#s12f1---map-setup-data-send)   | → Equipment | Map Setup Data Send |
| [S12F2](#s12f2---map-setup-data-acknowledge)   | ← Equipment | Map Setup Data Acknowledge |
| [S12F3](#s12f3---map-setup-data-request)   | → Equipment | Map Setup Data Request |
| [S12F4](#s12f4---map-setup-data-response)   | ← Equipment | Map Setup Data Response |
| [S12F5](#s12f5---map-transmit-inquire)   | → Equipment | Map Transmit Inquire |
| [S12F6](#s12f6---map-transmit-grant)   | ← Equipment | Map Transmit Grant |
| [S12F7](#s12f7---map-data-send-type-1)   | → Equipment | Map Data Send Type 1 |
| [S12F8](#s12f8---map-data-ack-type-1)   | ← Equipment | Map Data Ack Type 1 |
| [S12F9](#s12f9---map-data-send-type-2)   | → Equipment | Map Data Send Type 2 |
| [S12F10](#s12f10---map-data-ack-type-2)  | ← Equipment | Map Data Ack Type 2 |
| [S12F11](#s12f11---map-data-send-type-3)  | → Equipment | Map Data Send Type 3 |
| [S12F12](#s12f12---map-data-ack-type-3)  | ← Equipment | Map Data Ack Type 3 |
| [S12F13](#s12f13---map-data-request-type-1)  | → Equipment | Map Data Request Type 1 |
| [S12F14](#s12f14---map-data-type-1)  | ← Equipment | Map Data Type 1 |
| [S12F15](#s12f15---map-data-request-type-2)  | → Equipment | Map Data Request Type 2 |
| [S12F16](#s12f16---map-data-type-2)  | ← Equipment | Map Data Type 2 |
| [S12F17](#s12f17---map-data-request-type-3)  | → Equipment | Map Data Request Type 3 |
| [S12F18](#s12f18---map-data-type-3)  | ← Equipment | Map Data Type 3 |
| [S12F19](#s12f19---map-error-report-send)  | ↔ Host/Equipment | Map Error Report Send |

#### **S12F1 - Map Setup Data Send** {#s12f1---map-setup-data-send}
```
{L[15]
  MID
  IDTYP
  FNLOC
  FFROT
  ORLOC
  RPSEL
  {L[n]
    REFP
  }
  DUTMS
  XDIES
  YDIES
  ROWCT
  COLCT
  NULBC
  PRDCT
  PRAXI
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- FNLOC: Final Location (A)
- FFROT: Final Format Rotation (A)
- ORLOC: Origin Location (A)
- RPSEL: Reference Point Select (A)
- REFP: Reference Point (A)
- DUTMS: Die Unit Time Stamp (A)
- XDIES: X Dies (U1, U2, U4)
- YDIES: Y Dies (U1, U2, U4)
- ROWCT: Row Count (U1, U2, U4)
- COLCT: Column Count (U1, U2, U4)
- NULBC: Null Block Count (U1, U2, U4)
- PRDCT: Production Count (U1, U2, U4)
- PRAXI: Production Axis (A)

#### **S12F2 - Map Setup Data Acknowledge** {#s12f2---map-setup-data-acknowledge}
```
SDACK
```

**Parameters:**
- SDACK: Setup Data Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S12F3 - Map Setup Data Request** {#s12f3---map-setup-data-request}
```
{L[9]
  MID
  IDTYP
  MAPFT
  FNLOC
  FFROT
  ORLOC
  PRAXI
  BCEQU
  NULBC
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- MAPFT: Map Format (A)
- FNLOC: Final Location (A)
- FFROT: Final Format Rotation (A)
- ORLOC: Origin Location (A)
- PRAXI: Production Axis (A)
- BCEQU: Block Count Equal (U1, U2, U4)
- NULBC: Null Block Count (U1, U2, U4)

#### **S12F4 - Map Setup Data Response** {#s12f4---map-setup-data-response}
```
{L[15]
  MID
  IDTYP
  FNLOC
  ORLOC
  RPSEL
  {L[n]
    REFP
  }
  DUTMS
  XDIES
  YDIES
  ROWCT
  COLCT
  PRDCT
  BCEQU
  NULBC
  MLCL
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- FNLOC: Final Location (A)
- ORLOC: Origin Location (A)
- RPSEL: Reference Point Select (A)
- REFP: Reference Point (A)
- DUTMS: Die Unit Time Stamp (A)
- XDIES: X Dies (U1, U2, U4)
- YDIES: Y Dies (U1, U2, U4)
- ROWCT: Row Count (U1, U2, U4)
- COLCT: Column Count (U1, U2, U4)
- PRDCT: Production Count (U1, U2, U4)
- BCEQU: Block Count Equal (U1, U2, U4)
- NULBC: Null Block Count (U1, U2, U4)
- MLCL: Map Location (A)

#### **S12F5 - Map Transmit Inquire** {#s12f5---map-transmit-inquire}
```
{L[4]
  MID
  IDTYP
  MAPFT
  MLCL
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- MAPFT: Map Format (A)
- MLCL: Map Location (A)

#### **S12F6 - Map Transmit Grant** {#s12f6---map-transmit-grant}
```
GRNT1
```

**Parameters:**
- GRNT1: Grant Type 1 (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space

#### **S12F7 - Map Data Send Type 1** {#s12f7---map-data-send-type-1}
```
{L[3]
  MID
  IDTYP
  {L[n]
    {L[2]
      RSINF
      BINLT
    }
  }
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- RSINF: Row Information (A)
- BINLT: Binary Data (B)

#### **S12F8 - Map Data Ack Type 1** {#s12f8---map-data-ack-type-1}
```
MDACK
```

**Parameters:**
- MDACK: Map Data Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S12F9 - Map Data Send Type 2** {#s12f9---map-data-send-type-2}
```
{L[4]
  MID
  IDTYP
  STRP
  BINLT
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- STRP: Strip Data (A)
- BINLT: Binary Data (B)

#### **S12F10 - Map Data Ack Type 2** {#s12f10---map-data-ack-type-2}
```
MDACK
```

**Parameters:**
- MDACK: Map Data Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S12F11 - Map Data Send Type 3** {#s12f11---map-data-send-type-3}
```
{L[3]
  MID
  IDTYP
  {L[n]
    {L[2]
      XYPOS
      BINLT
    }
  }
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- XYPOS: XY Position (A)
- BINLT: Binary Data (B)

#### **S12F12 - Map Data Ack Type 3** {#s12f12---map-data-ack-type-3}
```
MDACK
```

**Parameters:**
- MDACK: Map Data Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S12F13 - Map Data Request Type 1** {#s12f13---map-data-request-type-1}
```
{L[2]
  MID
  IDTYP
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])

#### **S12F14 - Map Data Type 1** {#s12f14---map-data-type-1}
```
{L[3]
  MID
  IDTYP
  {L[n]
    {L[2]
      RSINF
      BINLT
    }
  }
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- RSINF: Row Information (A)
- BINLT: Binary Data (B)

#### **S12F15 - Map Data Request Type 2** {#s12f15---map-data-request-type-2}
```
{L[2]
  MID
  IDTYP
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])

#### **S12F16 - Map Data Type 2** {#s12f16---map-data-type-2}
```
{L[4]
  MID
  IDTYP
  STRP
  BINLT
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- STRP: Strip Data (A)
- BINLT: Binary Data (B)


#### **S12F17 - Map Data Request Type 3** {#s12f17---map-data-request-type-3}
```
{L[3]
  MID
  IDTYP
  SDBIN
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- SDBIN: Sub Data Binary (B)

#### **S12F18 - Map Data Type 3** {#s12f18---map-data-type-3}
```
{L[3]
  MID
  IDTYP
  {L[n]
    {L[2]
      XYPOS
      BINLT
    }
  }
}
```

**Parameters:**
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- XYPOS: XY Position (A)
- BINLT: Binary Data (B)

#### **S12F19 - Map Error Report Send** {#s12f19---map-error-report-send}
```
{L[2]
  MAPER
  DATLC
}
```

**Parameters:**
- MAPER: Map Error (A)
- DATLC: Data Location (A)



### Stream 13: Data Set Management
**Purpose**: Advanced data set handling and management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S13F1](#s13f1---send-data-set-send)   | ↔ Host/Equipment | Send Data Set Send |
| [S13F2](#s13f2---send-data-set-ack)   | ↔ Host/Equipment | Send Data Set Ack |
| [S13F3](#s13f3---open-data-set-request)   | ↔ Host/Equipment | Open Data Set Request |
| [S13F4](#s13f4---open-data-set-data)   | ↔ Host/Equipment | Open Data Set Data |
| [S13F5](#s13f5---read-data-set-request)   | ↔ Host/Equipment | Read Data Set Request |
| [S13F6](#s13f6---read-data-set-data)   | ↔ Host/Equipment | Read Data Set Data |
| [S13F7](#s13f7---close-data-set-send)   | ↔ Host/Equipment | Close Data Set Send |
| [S13F8](#s13f8---close-data-set-ack)   | ↔ Host/Equipment | Close Data Set Ack |
| [S13F9](#s13f9---reset-data-set-send)   | ↔ Host/Equipment | Reset Data Set Send |
| [S13F10](#s13f10---reset-data-set-ack)   | ↔ Host/Equipment | Reset Data Set Ack |
| [S13F11](#s13f11---data-set-obj-multi-block-inquire)   | ↔ Host/Equipment | Data Set Obj Multi-Block Inquire |
| [S13F12](#s13f12---data-set-obj-multi-block-grant)   | ↔ Host/Equipment | Data Set Obj Multi-Block Grant |
| [S13F13](#s13f13---table-data-send)   | ↔ Host/Equipment | Table Data Send |
| [S13F14](#s13f14---table-data-ack)   | ↔ Host/Equipment | Table Data Ack |
| [S13F15](#s13f15---table-data-request)   | ↔ Host/Equipment | Table Data Request |
| [S13F16](#s13f16---table-data)   | ↔ Host/Equipment | Table Data |

#### **S13F1 - Send Data Set Send** {#s13f1---send-data-set-send}
```
{L[1]
  DSNAME
}
```

**Parameters:**
- DSNAME: Data Set Name (A)
- Comment: S13F1 seems to have the L: wrapper that S13F2 is missing. Be prepared to receive DSNAME without the L:

#### **S13F2 - Send Data Set Ack** {#s13f2---send-data-set-ack}
```
{L[2]
  DSNAME
  ACKC13
}
```

**Parameters:**
- DSNAME: Data Set Name (A)
- ACKC13: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
- Comment: The standards have had an erroneous structure for years - the L:2 has been missing. Unfortunately some implementations have not realized it was an error. The latest Hume versions automagically create the L:2 wrapper when it is missing.

#### **S13F3 - Open Data Set Request** {#s13f3---open-data-set-request}
```
{L[3]
  HANDLE
  DSNAME
  CKPNT
}
```

**Parameters:**
- HANDLE: Handle (A)
- DSNAME: Data Set Name (A)
- CKPNT: Checkpoint (A)
- Comment: Sent by the receiver to open a data set for reading

#### **S13F4 - Open Data Set Data** {#s13f4---open-data-set-data}
```
{L[5]
  HANDLE
  DSNAME
  ACKC13
  RTYPE
  RECLEN
}
```

**Parameters:**
- HANDLE: Handle (A)
- DSNAME: Data Set Name (A)
- ACKC13: Acknowledge Code (B[1])
- RTYPE: Record Type (A)
- RECLEN: Record Length (U1, U2, U4)

#### **S13F5 - Read Data Set Request** {#s13f5---read-data-set-request}
```
{L[2]
  HANDLE
  READLN
}
```

**Parameters:**
- HANDLE: Handle (A)
- READLN: Read Length (U1, U2, U4)

#### **S13F6 - Read Data Set Data** {#s13f6---read-data-set-data}
```
{L[4]
  HANDLE
  ACKC13
  CKPNT
  {L[n]
    FILDAT
  }
}
```

**Parameters:**
- HANDLE: Handle (A)
- ACKC13: Acknowledge Code (B[1])
- CKPNT: Checkpoint (A)
- FILDAT: File Data (any format)

#### **S13F7 - Close Data Set Send** {#s13f7---close-data-set-send}
```
{L[1]
  HANDLE
}
```

**Parameters:**
- HANDLE: Handle (A)

#### **S13F8 - Close Data Set Ack** {#s13f8---close-data-set-ack}
```
{L[2]
  HANDLE
  ACKC13
}
```

**Parameters:**
- HANDLE: Handle (A)
- ACKC13: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error

#### **S13F9 - Reset Data Set Send** {#s13f9---reset-data-set-send}
```
{}
```

**Parameters:**
- Empty list (header only message)

#### **S13F10 - Reset Data Set Ack** {#s13f10---reset-data-set-ack}
```
{}
```

**Parameters:**
- Empty list (header only message)

#### **S13F11 - Data Set Obj Multi-Block Inquire** {#s13f11---data-set-obj-multi-block-inquire}
```
{L[3]
  DATAID
  OBJSPEC
  DATALENGTH
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specification (A)
- DATALENGTH: Data Length (U1, U2, U4)

#### **S13F12 - Data Set Obj Multi-Block Grant** {#s13f12---data-set-obj-multi-block-grant}
```
GRANT
```

**Parameters:**
- GRANT: Grant signal (B[1])
  - 0: Not granted
  - 1: Granted

#### **S13F13 - Table Data Send** {#s13f13---table-data-send}
```
{L[8]
  DATAID
  OBJSPEC
  TBLTYP
  TBLID
  TBLCMD
  {L[n]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[c]
    COLHDR
  }
  {L[r]
    {L[m]
      TBLELT
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specification (A)
- TBLTYP: Table Type (A)
- TBLID: Table ID (A)
- TBLCMD: Table Command (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- COLHDR: Column Header (A)
- TBLELT: Table Element (any format)
- Comment: The first element of every row is a primary key value which identifies the row. The row items correspond in sequence to the column headers. E58 uses attributes NumCols, NumRows, and DataLength

#### **S13F14 - Table Data Ack** {#s13f14---table-data-ack}
```
{L[2]
  TBLACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- TBLACK: Table Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S13F15 - Table Data Request** {#s13f15---table-data-request}
```
{L[7]
  DATAID
  OBJSPEC
  TBLTYP
  TBLID
  TBLCMD
  {L[p]
    COLHDR
  }
  {L[q]
    TBLELT
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specification (A)
- TBLTYP: Table Type (A)
- TBLID: Table ID (A)
- TBLCMD: Table Command (A)
- COLHDR: Column Header (A)
- TBLELT: Table Element (any format)
- Comment: Either p or q or both are 0.

#### **S13F16 - Table Data** {#s13f16---table-data}
```
{L[6]
  TBLTYP
  TBLID
  {L[n]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[c]
    COLHDR
  }
  {L[r]
    {L[c]
      TBLELT
    }
  }
  {L[2]
    TBLACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- TBLTYP: Table Type (A)
- TBLID: Table ID (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- COLHDR: Column Header (A)
- TBLELT: Table Element (any format)
- TBLACK: Table Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


### Stream 14: Object Services
**Purpose**: Object-oriented data management and services

| Message | Direction | Description |
|---------|-----------|-------------|
| [S14F1](#s14f1---get-attributes-request)   | → Equipment | Get Attributes Request |
| [S14F2](#s14f2---attribute-data)   | ← Equipment | Attribute Data |
| [S14F3](#s14f3---set-attributes)   | → Equipment | Set Attributes |
| [S14F4](#s14f4---set-attributes-reply)   | ← Equipment | Set Attributes Reply |
| [S14F5](#s14f5---get-type-data)   | → Equipment | Get Type Data |
| [S14F6](#s14f6---type-data)   | ← Equipment | Type Data |
| [S14F7](#s14f7---get-attribute-names)   | → Equipment | Get Attribute Names |
| [S14F8](#s14f8---attribute-names)   | ← Equipment | Attribute Names |
| [S14F9](#s14f9---create-obj-request)   | → Equipment | Create Object Request |
| [S14F10](#s14f10---create-obj-ack)   | ← Equipment | Create Object Acknowledge |
| [S14F11](#s14f11---delete-obj-request)   | → Equipment | Delete Object Request |
| [S14F12](#s14f12---delete-obj-ack)   | ← Equipment | Delete Object Acknowledge |
| [S14F13](#s14f13---object-attach-request)   | → Equipment | Object Attach Request |
| [S14F14](#s14f14---object-attach-ack)   | ← Equipment | Object Attach Acknowledge |
| [S14F15](#s14f15---attached-obj-action-req)   | → Equipment | Attached Object Action Request |
| [S14F16](#s14f16---attached-obj-action-ack)   | ← Equipment | Attached Object Action Acknowledge |
| [S14F17](#s14f17---supervised-obj-action-req)   | → Equipment | Supervised Object Action Request |
| [S14F18](#s14f18---supervised-obj-action-ack)   | ← Equipment | Supervised Object Action Acknowledge |
| [S14F19](#s14f19---generic-service-req)   | → Equipment | Generic Service Request |
| [S14F20](#s14f20---generic-service-ack)   | ← Equipment | Generic Service Acknowledge |
| [S14F21](#s14f21---generic-service-completion)   | → Equipment | Generic Service Completion |
| [S14F22](#s14f22---generic-service-comp-ack)   | ← Equipment | Generic Service Completion Acknowledge |
| [S14F23](#s14f23---multi-block-generic-service-inquire)   | → Equipment | Multi-block Generic Service Inquire |
| [S14F24](#s14f24---multi-block-generic-service-grant)   | ← Equipment | Multi-block Generic Service Grant |
| [S14F25](#s14f25---service-name-request)   | → Equipment | Service Name Request |
| [S14F26](#s14f26---service-name-data)   | ← Equipment | Service Name Data |
| [S14F27](#s14f27---service-parameter-name-req)   | → Equipment | Service Parameter Name Request |
| [S14F28](#s14f28---service-parameter-name-data)   | ← Equipment | Service Parameter Name Data |

#### **S14F1 - Get Attributes Request** {#s14f1---get-attributes-request}
```
{L[5]
  OBJSPEC
  OBJTYPE
  {L[i]
    OBJID
  }
  {L[q]
    {L[3]
      ATTRID
      ATTRDATA
      ATTRRELN
    }
  }
  {L[a]
    ATTRID
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJTYPE: Object Type (A)
- OBJID: Object ID (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- ATTRRELN: Attribute Relation (A)
- Comment: List lengths can be 0, and OBJSPEC can be zero-length.

#### **S14F2 - Attribute Data** {#s14f2---attribute-data}
```
{L[2]
  {L[n]
    {L[2]
      OBJID
      {L[a]
        {L[2]
          ATTRID
          ATTRDATA
        }
      }
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJID: Object ID (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F3 - Set Attributes** {#s14f3---set-attributes}
```
{L[4]
  OBJSPEC
  OBJTYPE
  {L[i]
    OBJID
  }
  {L[n]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJTYPE: Object Type (A)
- OBJID: Object ID (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)


#### **S14F4 - Set Attributes Reply** {#s14f4---set-attributes-reply}
```
{L[2]
  {L[i]
    {L[2]
      OBJID
      {L[n]
        {L[2]
          ATTRID
          ATTRDATA
        }
      }
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJID: Object ID (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F5 - Get Type Data** {#s14f5---get-type-data}
```
OBJSPEC
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- Comment: Asks for the types of objects owned by the type of specified object

#### **S14F6 - Type Data** {#s14f6---type-data}
```
{L[2]
  {L[n]
    OBJTYPE
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJTYPE: Object Type (A)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F7 - Get Attribute Names** {#s14f7---get-attribute-names}
```
{L[2]
  OBJSPEC
  {L[n]
    OBJTYPE
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJTYPE: Object Type (A)

#### **S14F8 - Attribute Names** {#s14f8---attribute-names}
```
{L[2]
  {L[n]
    {L[2]
      OBJTYPE
      {L[a]
        ATTRID
      }
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJTYPE: Object Type (A)
- ATTRID: Attribute ID (A)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F9 - Create Object Request** {#s14f9---create-obj-request}
```
{L[3]
  OBJSPEC
  OBJTYPE
  {L[a]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJTYPE: Object Type (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)

#### **S14F10 - Create Object Acknowledge** {#s14f10---create-obj-ack}
```
{L[3]
  OBJSPEC
  {L[b]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F11 - Delete Object Request** {#s14f11---delete-obj-request}
```
{L[2]
  OBJSPEC
  {L[a]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)

#### **S14F12 - Delete Object Acknowledge** {#s14f12---delete-obj-ack}
```
{L[2]
  {L[b]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F13 - Object Attach Request** {#s14f13---object-attach-request}
```
{L[2]
  OBJSPEC
  {L[a]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)


#### **S14F14 - Object Attach Acknowledge** {#s14f14---object-attach-ack}
```
{L[3]
  OBJTOKEN
  {L[b]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJTOKEN: Object Token (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F15 - Attached Object Action Request** {#s14f15---attached-obj-action-req}
```
{L[4]
  OBJSPEC
  OBJCMD
  OBJTOKEN
  {L[a]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJCMD: Object Command (A)
- OBJTOKEN: Object Token (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)

#### **S14F16 - Attached Object Action Acknowledge** {#s14f16---attached-obj-action-ack}
```
{L[2]
  {L[b]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F17 - Supervised Object Action Request** {#s14f17---supervised-obj-action-req}
```
{L[4]
  OBJSPEC
  OBJCMD
  TARGETSPEC
  {L[a]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJCMD: Object Command (A)
- TARGETSPEC: Target Specification (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)

#### **S14F18 - Supervised Object Action Acknowledge** {#s14f18---supervised-obj-action-ack}
```
{L[2]
  {L[b]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F19 - Generic Service Request** {#s14f19---generic-service-req}
```
{L[5]
  DATAID
  OPID
  OBJSPEC
  SVCNAME
  {L[m]
    {L[2]
      SPNAME
      SPVAL
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OPID: Operation ID (A)
- OBJSPEC: Object Specification (A)
- SVCNAME: Service Name (A)
- SPNAME: Service Parameter Name (A)
- SPVAL: Service Parameter Value (any format)

#### **S14F20 - Generic Service Acknowledge** {#s14f20---generic-service-ack}
```
{L[4]
  SVCACK
  LINKID
  {L[n]
    {L[2]
      SPNAME
      SPVAL
    }
  }
  {L[2]
    SVCACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- SVCACK: Service Acknowledge (B[1])
- LINKID: Link ID (A)
- SPNAME: Service Parameter Name (A)
- SPVAL: Service Parameter Value (any format)
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)
- Comment: It is not a mistake that SVCACK is included twice

#### **S14F21 - Generic Service Completion** {#s14f21---generic-service-completion}
```
{L[5]
  DATAID
  OPID
  LINKID
  {L[n]
    {L[2]
      SPNAME
      SPVAL
    }
  }
  {L[2]
    SVCACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OPID: Operation ID (A)
- LINKID: Link ID (A)
- SPNAME: Service Parameter Name (A)
- SPVAL: Service Parameter Value (any format)
- SVCACK: Service Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F22 - Generic Service Completion Acknowledge** {#s14f22---generic-service-comp-ack}
```
DATAACK
```

**Parameters:**
- DATAACK: Data Acknowledge (B[1])

#### **S14F23 - Multi-block Generic Service Inquire** {#s14f23---multi-block-generic-service-inquire}
```
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- DATALENGTH: Data Length (U1, U2, U4)
- Comment: You are advised not to implement this message.

#### **S14F24 - Multi-block Generic Service Grant** {#s14f24---multi-block-generic-service-grant}
```
GRANT
```

**Parameters:**
- GRANT: Grant signal (B[1])
  - 0: Not granted
  - 1: Granted

#### **S14F25 - Service Name Request** {#s14f25---service-name-request}
```
{L[2]
  OBJSPEC
  {L[n]
    OBJTYPE
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJTYPE: Object Type (A)

#### **S14F26 - Service Name Data** {#s14f26---service-name-data}
```
{L[2]
  {L[n]
    {L[2]
      OBJTYPE
      {L[a]
        SVCNAME
      }
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- OBJTYPE: Object Type (A)
- SVCNAME: Service Name (A)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)

#### **S14F27 - Service Parameter Name Request** {#s14f27---service-parameter-name-req}
```
{L[3]
  OBJSPEC
  OBJTYPE
  {L[n]
    SVCNAME
  }
}
```

**Parameters:**
- OBJSPEC: Object Specification (A)
- OBJTYPE: Object Type (A)
- SVCNAME: Service Name (A)

#### **S14F28 - Service Parameter Name Data** {#s14f28---service-parameter-name-data}
```
{L[2]
  {L[n]
    {L[2]
      SVCNAME
      {L[a]
        SPNAME
      }
    }
  }
  {L[2]
    OBJACK
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- SVCNAME: Service Name (A)
- SPNAME: Service Parameter Name (A)
- OBJACK: Object Acknowledge (B[1])
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)



### Stream 15: Recipe Management
**Purpose**: Recipe management and control

| Message | Direction | Description |
|---------|-----------|-------------|
| [S15F1](#s15f1---recipe-management-multi-block-inquire)   | ↔ Host/Equipment | Recipe Management Multi-Block Inquire |
| [S15F2](#s15f2---recipe-management-multi-block-grant)   | ↔ Host/Equipment | Recipe Management Multi-block Grant |
| [S15F3](#s15f3---recipe-namespace-action-req)   | ↔ Host/Equipment | Recipe Namespace Action Req |
| [S15F4](#s15f4---recipe-namespace-action)   | ↔ Host/Equipment | Recipe Namespace Action |
| [S15F5](#s15f5---recipe-namespace-rename-req)   | ↔ Host/Equipment | Recipe Namespace Rename Req |
| [S15F6](#s15f6---recipe-namespace-rename-ack)   | ↔ Host/Equipment | Recipe Namespace Rename Ack |
| [S15F7](#s15f7---recipe-space-req)   | ↔ Host/Equipment | Recipe Space Req |
| [S15F8](#s15f8---recipe-space-data)   | ↔ Host/Equipment | Recipe Space Data |
| [S15F9](#s15f9---recipe-status-request)   | ↔ Host/Equipment | Recipe Status Request |
| [S15F10](#s15f10---recipe-status-data)   | ↔ Host/Equipment | Recipe Status Data |
| [S15F11](#s15f11---recipe-version-request)   | ↔ Host/Equipment | Recipe Version Request |
| [S15F12](#s15f12---recipe-version-data)   | ↔ Host/Equipment | Recipe Version Data |
| [S15F13](#s15f13---recipe-create-req)   | ↔ Host/Equipment | Recipe Create Req |
| [S15F14](#s15f14---recipe-create-ack)   | ↔ Host/Equipment | Recipe Create Ack |
| [S15F15](#s15f15---recipe-store-req)   | ↔ Host/Equipment | Recipe Store Req |
| [S15F16](#s15f16---recipe-store-ack)   | ↔ Host/Equipment | Recipe Store Ack |
| [S15F17](#s15f17---recipe-retrieve-req)   | ↔ Host/Equipment | Recipe Retrieve Req |
| [S15F18](#s15f18---recipe-retrieve-data)   | ↔ Host/Equipment | Recipe Retrieve Data |
| [S15F19](#s15f19---recipe-rename-req)   | ↔ Host/Equipment | Recipe Rename Req |
| [S15F20](#s15f20---recipe-rename-ack)   | ↔ Host/Equipment | Recipe Rename Ack |
| [S15F21](#s15f21---recipe-action-req)   | ↔ Host/Equipment | Recipe Action Req |
| [S15F22](#s15f22---recipe-action-ack)   | ↔ Host/Equipment | Recipe Action Ack |
| [S15F23](#s15f23---recipe-descriptor-req)   | ↔ Host/Equipment | Recipe Descriptor Req |
| [S15F24](#s15f24---recipe-descriptor-data)   | ↔ Host/Equipment | Recipe Descriptor Data |
| [S15F25](#s15f25---recipe-parameter-update-req)   | ↔ Host/Equipment | Recipe Parameter Update Req |
| [S15F26](#s15f26---recipe-parameter-update-ack)   | ↔ Host/Equipment | Recipe Parameter Update Ack |
| [S15F27](#s15f27---recipe-download-req)   | → Host | Recipe Download Req |
| [S15F28](#s15f28---recipe-download-ack)   | ← Equipment | Recipe Download Ack |
| [S15F29](#s15f29---recipe-verify-req)   | → Host | Recipe Verify Req |
| [S15F30](#s15f30---recipe-verify-ack)   | ← Equipment | Recipe Verify Ack |
| [S15F31](#s15f31---recipe-unload-req)   | → Host | Recipe Unload Req |
| [S15F32](#s15f32---recipe-unload-data)   | ← Equipment | Recipe Unload Data |
| [S15F33](#s15f33---recipe-select-req)   | → Host | Recipe Select Req |
| [S15F34](#s15f34---recipe-select-ack)   | ← Equipment | Recipe Select Ack |
| [S15F35](#s15f35---recipe-delete-req)   | → Host | Recipe Delete Req |
| [S15F36](#s15f36---recipe-delete-ack)   | ← Equipment | Recipe Delete Ack |
| [S15F37](#s15f37---drns-segment-approve-action-req)   | ↔ Host/Equipment | DRNS Segment Approve Action Req |
| [S15F38](#s15f38---drns-segment-approve-action-ack)   | ↔ Host/Equipment | DRNS Segment Approve Action Ack |
| [S15F39](#s15f39---drns-recorder-seg-req)   | ↔ Host/Equipment | DRNS Recorder Seg Req |
| [S15F40](#s15f40---drns-recorder-seg-ack)   | ↔ Host/Equipment | DRNS Recorder Seg Ack |
| [S15F41](#s15f41---drns-recorder-mod-req)   | ↔ Host/Equipment | DRNS Recorder Mod Req |
| [S15F42](#s15f42---drns-recorder-mod-ack)   | ↔ Host/Equipment | DRNS Recorder Mod Ack |
| [S15F43](#s15f43---drns-get-change-req)   | ↔ Host/Equipment | DRNS Get Change Req |
| [S15F44](#s15f44---drns-get-change-ack)   | ↔ Host/Equipment | DRNS Get Change Ack |
| [S15F45](#s15f45---drns-mgr-seg-aprvl-req)   | ↔ Host/Equipment | DRNS Mgr Seg Aprvl Req |
| [S15F46](#s15f46---drns-mgr-seg-aprvl-ack)   | ↔ Host/Equipment | DRNS Mgr Seg Aprvl Ack |
| [S15F47](#s15f47---drns-mgr-rebuild-req)   | ↔ Host/Equipment | DRNS Mgr Rebuild Req |
| [S15F48](#s15f48---drns-mgr-rebuild-ack)   | ↔ Host/Equipment | DRNS Mgr Rebuild Ack |
| [S15F49](#s15f49---large-recipe-download-req)   | → Host | Large Recipe Download Req |
| [S15F50](#s15f50---large-recipe-download-ack)   | ← Equipment | Large Recipe Download Ack |
| [S15F51](#s15f51---large-recipe-upload-req)   | → Host | Large Recipe Upload Req |
| [S15F52](#s15f52---large-recipe-upload-ack)   | ← Equipment | Large Recipe Upload Ack |
| [S15F53](#s15f53---recipe-verification-send)   | ← Equipment | Recipe Verification Send |
| [S15F54](#s15f54---recipe-verification-ack)   | → Host | Recipe Verification Ack |

#### **S15F1 - Recipe Management Multi-Block Inquire** {#s15f1---recipe-management-multi-block-inquire}
**Comment**: E5 fails to mention the message type is optional for HSMS

**Format**:
```
{L[3]
DATAID
RCPSPEC
RMDATASIZE
}
```

#### **S15F2 - Recipe Management Multi-block Grant** {#s15f2---recipe-management-multi-block-grant}
**Format**:
```
RMGRNT
```

#### **S15F3 - Recipe Namespace Action Req** {#s15f3---recipe-namespace-action-req}
**Format**:
```
{L[2]
RMNSSPEC
RMNSCMD
}
```

#### **S15F4 - Recipe Namespace Action** {#s15f4---recipe-namespace-action}
**Format**:
```
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
```

#### **S15F5 - Recipe Namespace Rename Req** {#s15f5---recipe-namespace-rename-req}
**Format**:
```
{L[2]
RMNSSPEC
RMNEWNS
}
```

#### **S15F6 - Recipe Namespace Rename Ack** {#s15f6---recipe-namespace-rename-ack}
**Format**:
```
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
```

#### **S15F7 - Recipe Space Req** {#s15f7---recipe-space-req}
**Format**:
```
OBJSPEC
```

#### **S15F8 - Recipe Space Data** {#s15f8---recipe-space-data}
**Format**:
```
{L[2]
RMSPACE
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F9 - Recipe Status Request** {#s15f9---recipe-status-request}
**Format**:
```
RCPSPEC
```

#### **S15F10 - Recipe Status Data** {#s15f10---recipe-status-data}
**Format**:
```
{L[3]
RCPSTAT
RCPVERS
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F11 - Recipe Version Request** {#s15f11---recipe-version-request}
**Format**:
```
{L[4]
RMNSSPEC
RCPCLASS
RCPNAME
AGENT
}
```

#### **S15F12 - Recipe Version Data** {#s15f12---recipe-version-data}
**Format**:
```
{L[3]
AGENT
RCPVERS
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F13 - Recipe Create Req** {#s15f13---recipe-create-req}
**Format**:
```
{L[5]
DATAID
RCPUPDT
RCPSPEC
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
RCPBODY
}
```

#### **S15F14 - Recipe Create Ack** {#s15f14---recipe-create-ack}
**Format**:
```
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
```

#### **S15F15 - Recipe Store Req** {#s15f15---recipe-store-req}
**Comment**: L[2]* can be L[2] or L:0; E5 documentation is inadequate for L:q other than L[3]

**Format**:
```
{L[4]
DATAID
RCPSPEC
RCPSECCODE
{L[3]
{L[2]*
RCPSECNM
{L:g
{L[2]
RCPATTRID
RCPATTRDATA
}
}
}
RCPBODY
{L[n]
{L[2]
RCPSECNM
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
}
}
}
}
```

#### **S15F16 - Recipe Store Ack** {#s15f16---recipe-store-ack}
**Format**:
```
{L[2]
RCPSECCODE
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F17 - Recipe Retrieve Req** {#s15f17---recipe-retrieve-req}
**Format**:
```
{L[2]
RCPSPEC
RCPSECCODE
}
```

#### **S15F18 - Recipe Retrieve Data** {#s15f18---recipe-retrieve-data}
**Format**:
```
{L[2]
{L:q
{L:r
RCPSECNM
{L:g
{L[2]
RCPATTRID
RCPATTRDATA
}
}
}
RCPBODY
{L[n]
{L[2]
RCPSECNM
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
}
}
}
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F19 - Recipe Rename Req** {#s15f19---recipe-rename-req}
**Format**:
```
{L[3]
RCPSPEC
RCPRENAME
RCPNEWID
}
```

#### **S15F20 - Recipe Rename Ack** {#s15f20---recipe-rename-ack}
**Format**:
```
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
```

#### **S15F21 - Recipe Action Req** {#s15f21---recipe-action-req}
**Format**:
```
{L:6
DATAID
RCPCMD
RMNSSPEC
OPID
AGENT
{L[n]
RCPID
}
}
```

#### **S15F22 - Recipe Action Ack** {#s15f22---recipe-action-ack}
**Format**:
```
{L[4]
AGENT
LINKID
RCPCMD
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F23 - Recipe Descriptor Req** {#s15f23---recipe-descriptor-req}
**Format**:
```
{L[3]
DATAID
OBJSPEC
{L[n]
RCPID
}
}
```

#### **S15F24 - Recipe Descriptor Data** {#s15f24---recipe-descriptor-data}
**Format**:
```
{L[2]
{L[n]
{L[n]
{L[3]*
RCPDESCNM
RCPDESCTIME
RCPDESCLTH
}
}
}
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F25 - Recipe Parameter Update Req** {#s15f25---recipe-parameter-update-req}
**Format**:
```
{L[4]
DATAID
RMNSSPEC
AGENT
{L[n]
{L[3]
RCPPARNM
RCPPARVAL
RCPPARRULE
}
}
}
```

#### **S15F26 - Recipe Parameter Update Ack** {#s15f26---recipe-parameter-update-ack}
**Format**:
```
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
```

#### **S15F27 - Recipe Download Req** {#s15f27---recipe-download-req}
**Format**:
```
{L[5]
DATAID
RCPOWCODE
RCPSPEC
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
RCPBODY
}
```

#### **S15F28 - Recipe Download Ack** {#s15f28---recipe-download-ack}
**Format**:
```
{L[3]
RCPID
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F29 - Recipe Verify Req** {#s15f29---recipe-verify-req}
**Format**:
```
{L[4]
DATAID
OPID
RESPEC
{L[n]
RCPID
}
}
```

#### **S15F30 - Recipe Verify Ack** {#s15f30---recipe-verify-ack}
**Format**:
```
{L[5]
OPID
LINKID
RCPID
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F31 - Recipe Unload Req** {#s15f31---recipe-unload-req}
**Format**:
```
RCPSPEC
```

#### **S15F32 - Recipe Unload Data** {#s15f32---recipe-unload-data}
**Format**:
```
{L[4]
RCPSPEC
{L[n]
{L[2]
RCPATTRID
RCPATTRDATA
}
}
RCPBODY
{L[2]
RMACK
{L:p
{L[2]
ERRCODE
ERRTEXT
}
}
}
}
```

#### **S15F33 - Recipe Select Req** {#s15f33---recipe-select-req}
**Format**:
```
{L[3]
DATAID
RESPEC
{L:r
{L[2]
RCPID
{L:p
{L[2]
RCPPARNM
RCPPARVAL
}
}
}
}
}
```
 
#### **S15F34 - Recipe Select Acknowledge** {#s15f34---recipe-select-ack}
```
{L[2]
  RMACK
  {L:p
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F35 - Recipe Delete Request** {#s15f35---recipe-delete-req}
```
{L[4]
  DATAID
  RESPEC
  RCPDEL
  {L[n]
    RCPID
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- RESPEC: Recipe Specification (A)
- RCPDEL: Recipe Delete (B[1])
  - 0: Delete
  - 1: Keep
- RCPID: Recipe ID (A)


#### **S15F36 - Recipe Delete Acknowledge** {#s15f36---recipe-delete-ack}
```
{L[2]
  RMACK
  {L:p
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F37 - DRNS Segment Approve Action Request** {#s15f37---drns-segment-approve-action-req}
```
{L[6]
  RMSEGSPEC
  OBJTOKEN
  RMGRNT
  OPID
  RCPID
  RMCHGTYPE
}
```

**Parameters:**
- RMSEGSPEC: Recipe Management Segment Specification (A)
- OBJTOKEN: Object Token (A)
- RMGRNT: Recipe Management Grant (B[1])
  - 0: Granted
  - 1: Not granted
- OPID: Operation ID (A)
- RCPID: Recipe ID (A)
- RMCHGTYPE: Recipe Management Change Type (A)


#### **S15F38 - DRNS Segment Approve Action Acknowledge** {#s15f38---drns-segment-approve-action-ack}
```
{L[2]
  RMACK
  {L:p
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F39 - DRNS Recorder Segment Request** {#s15f39---drns-recorder-seg-req}
```
{L[5]
  DATAID
  RMNSCMD
  RMRECSPEC
  RMSEGSPEC
  OBJTOKEN
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- RMNSCMD: Recipe Management Namespace Command (A)
- RMRECSPEC: Recipe Management Recorder Specification (A)
- RMSEGSPEC: Recipe Management Segment Specification (A)
- OBJTOKEN: Object Token (A)


#### **S15F40 - DRNS Recorder Segment Acknowledge** {#s15f40---drns-recorder-seg-ack}
```
{L[2]
  RMACK
  {L:p
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F41 - DRNS Recorder Module Request** {#s15f41---drns-recorder-mod-req}
```
{L[5]
  DATAID
  RMRECSPEC
  OBJTOKEN
  RMNSCMD
  {L[c]
    RCPID
    RCPNEWID
    RMSEGSPEC
    RMCHGTYPE
    OPID
    TIMESTAMP
    RMREQUESTOR
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- RMRECSPEC: Recipe Management Recorder Specification (A)
- OBJTOKEN: Object Token (A)
- RMNSCMD: Recipe Management Namespace Command (A)
- RCPID: Recipe ID (A)
- RCPNEWID: Recipe New ID (A)
- RMSEGSPEC: Recipe Management Segment Specification (A)
- RMCHGTYPE: Recipe Management Change Type (A)
- OPID: Operation ID (A)
- TIMESTAMP: Time Stamp (A)
- RMREQUESTOR: Recipe Management Requestor (A)


#### **S15F42 - DRNS Recorder Module Acknowledge** {#s15f42---drns-recorder-mod-ack}
```
{L[2]
  RMACK
  {L:p
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F43 - DRNS Get Change Request** {#s15f43---drns-get-change-req}
```
{L[3]
  DATAID
  OBJSPEC
  TARGETSPEC
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specification (A)
- TARGETSPEC: Target Specification (A)


#### **S15F44 - DRNS Get Change Acknowledge** {#s15f44---drns-get-change-ack}
```
{L[2]
  {L[n]
    {L[7]
      RCPID
      RCPNEWID
      RMSEGSPEC
      RMCHGTYPE
      OPID
      TIMESTAMP
      RMREQUESTOR
    }
  }
  {L[2]
    RMACK
    {L:p
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- RCPID: Recipe ID (A)
- RCPNEWID: Recipe New ID (A)
- RMSEGSPEC: Recipe Management Segment Specification (A)
- RMCHGTYPE: Recipe Management Change Type (A)
- OPID: Operation ID (A)
- TIMESTAMP: Time Stamp (A)
- RMREQUESTOR: Recipe Management Requestor (A)
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F45 - DRNS Manager Segment Approval Request** {#s15f45---drns-mgr-seg-aprvl-req}
```
{L[4]
  DATAID
  RCPSPEC
  RCPNEWID
  RMCHGTYPE
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- RCPSPEC: Recipe Specification (A)
- RCPNEWID: Recipe New ID (A)
- RMCHGTYPE: Recipe Management Change Type (A)


#### **S15F46 - DRNS Manager Segment Approval Acknowledge** {#s15f46---drns-mgr-seg-aprvl-ack}
```
{L[3]
  RMCHGTYPE
  RMGRNT
  OPID
}
```

**Parameters:**
- RMCHGTYPE: Recipe Management Change Type (A)
- RMGRNT: Recipe Management Grant (B[1])
  - 0: Granted
  - 1: Not granted
- OPID: Operation ID (A)


#### **S15F47 - DRNS Manager Rebuild Request** {#s15f47---drns-mgr-rebuild-req}
```
{L[5]
  DATAID
  OBJSPEC
  RMNSSPEC
  RMRECSPEC
  {L[n]
    RMSEGSPEC
  }
}
```

**Parameters:**
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specification (A)
- RMNSSPEC: Recipe Management Namespace Specification (A)
- RMRECSPEC: Recipe Management Recorder Specification (A)
- RMSEGSPEC: Recipe Management Segment Specification (A)


#### **S15F48 - DRNS Manager Rebuild Acknowledge** {#s15f48---drns-mgr-rebuild-ack}
```
{L[2]
  RMACK
  {L:p
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F49 - Large Recipe Download Request** {#s15f49---large-recipe-download-req}
```
{L[2]
  DSNAME
  RCPOWCODE
}
```

**Parameters:**
- DSNAME: Data Set Name (A) - The RCPSPEC for Stream 13 transfer
- RCPOWCODE: Recipe Owner Code (A)


#### **S15F50 - Large Recipe Download Acknowledge** {#s15f50---large-recipe-download-ack}
```
ACKC15
```

**Parameters:**
- ACKC15: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error


#### **S15F51 - Large Recipe Upload Request** {#s15f51---large-recipe-upload-req}
```
DSNAME
```

**Parameters:**
- DSNAME: Data Set Name (A) - The RCPSPEC used in Stream 13


#### **S15F52 - Large Recipe Upload Acknowledge** {#s15f52---large-recipe-upload-ack}
```
ACKC15
```

**Parameters:**
- ACKC15: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error


#### **S15F53 - Recipe Verification Send** {#s15f53---recipe-verification-send}
```
{L[3]
  RCPSPEC
  RCPID
  {L[2]
    RMACK
    {L[n]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

**Parameters:**
- RCPSPEC: Recipe Specification (A)
- RCPID: Recipe ID (A)
- RMACK: Recipe Management Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)


#### **S15F54 - Recipe Verification Acknowledge** {#s15f54---recipe-verification-ack}
```
{}
```

**Parameters:**
- Empty message (header only)




### Stream 16: Process Job Management
**Purpose**: Process job creation, control, and management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S16F1](#s16f1---process-job-data-mbi)   | → Equipment | Process Job Data MBI |
| [S16F2](#s16f2---pjd-mbi-grant)   | ← Equipment | PJD MBI Grant |
| [S16F3](#s16f3---process-job-create-req)   | → Equipment | Process Job Create Req |
| [S16F4](#s16f4---process-job-create-ack)   | ← Equipment | Process Job Create Ack |
| [S16F5](#s16f5---process-job-cmd-req)   | → Equipment | Process Job Cmd Req |
| [S16F6](#s16f6---process-job-cmd-ack)   | ← Equipment | Process Job Cmd Ack |
| [S16F7](#s16f7---process-job-alert-notify)   | ← Equipment | Process Job Alert Notify |
| [S16F8](#s16f8---process-job-alert-ack)   | → Equipment | Process Job Alert Ack |
| [S16F9](#s16f9---process-job-event-notify)   | ← Equipment | Process Job Event Notify |
| [S16F10](#s16f10---process-job-event-ack)  | → Equipment | Process Job Event Ack |
| [S16F11](#s16f11---prjobcreateenh)  | → Equipment | PRJobCreateEnh |
| [S16F12](#s16f12---prjobcreateenh-ack)  | ← Equipment | PRJobCreateEnh Ack |
| [S16F15](#s16f15---prjobmulticreate)  | → Equipment | PRJobMultiCreate |
| [S16F16](#s16f16---prjobmulticreate-ack)  | ← Equipment | PRJobMultiCreate Ack |
| [S16F17](#s16f17---prjobdequeue)  | → Equipment | PRJobDequeue |
| [S16F18](#s16f18---prjobdequeue-ack)  | ← Equipment | PRJobDequeue Ack |
| [S16F19](#s16f19---prjob-list-req)  | → Equipment | PRJob List Req |
| [S16F20](#s16f20---prjob-list-data)  | ← Equipment | PRJob List Data |
| [S16F21](#s16f21---prjob-create-limit-req)  | → Equipment | PRJob Create Limit Req |
| [S16F22](#s16f22---prjob-create-limit-data)  | ← Equipment | PRJob Create Limit Data |
| [S16F23](#s16f23---prjob-recipe-variable-set)  | → Equipment | PRJob Recipe Variable Set |
| [S16F24](#s16f24---prjob-recipe-variable-ack)  | ← Equipment | PRJob Recipe Variable Ack |
| [S16F25](#s16f25---prjob-start-method-set)  | → Equipment | PRJob Start Method Set |
| [S16F26](#s16f26---prjob-start-method-ack)  | ← Equipment | PRJob Start Method Ack |
| [S16F27](#s16f27---control-job-command)  | → Equipment | Control Job Command |
| [S16F28](#s16f28---control-job-command-ack)  | ← Equipment | Control Job Command Ack |
| [S16F29](#s16f29---prsetmtrlorder)  | → Equipment | PRSetMtrlOrder |
| [S16F30](#s16f30---prsetmtrlorder-ack)  | ← Equipment | PRSetMtrlOrder Ack | 

#### **S16F1 - Process Job Data MBI** {#s16f1---process-job-data-mbi}
```

{L[2]
  DATAID
  DATALENGTH
}

```
```

- DATAID: Data ID (U1, U2, U4, or A)
- DATALENGTH: Data Length (U1, U2, U4)
```
 

#### **S16F2 - PJD MBI Grant** {#s16f2---pjd-mbi-grant}
```

GRANT

```
```

- GRANT: Grant Code (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space
```

#### **S16F3 - Process Job Create Req** {#s16f3---process-job-create-req}
```

{L[5]
  DATAID
  MF
  {L[n]
    MID
  }
  {L[3]
    PRRECIPEMETHOD
    RCPSPEC
    {L[m]
      {L[2]
        RCPPARNM
        RCPPARVAL
      }
    }
  }
  PRPROCESSSTART
}

```
```

- DATAID: Data ID (U1, U2, U4, or A)
- MF: Material Format (U1)
- MID: Material ID (A)
- PRRECIPEMETHOD: Process Recipe Method (A)
- RCPSPEC: Recipe Specification (A)
- RCPPARNM: Recipe Parameter Name (A)
- RCPPARVAL: Recipe Parameter Value (any format)
- PRPROCESSSTART: Process Process Start (A)
```

#### **S16F4 - Process Job Create Ack** {#s16f4---process-job-create-ack}
```

{L[2]
  PRJOBID
  {L[2]
    ACKA
    {L[n]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}

```
```

- PRJOBID: Process Job ID (A)
- ACKA: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)
```

#### **S16F5 - Process Job Cmd Req** {#s16f5---process-job-cmd-req}
```

{L[4]
  DATAID
  PRJOBID
  PRCMDNAME
  {L[n]
    {L[2]
      CPNAME
      CPVAL
    }
  }
}

```
```

- DATAID: Data ID (U1, U2, U4, or A)
- PRJOBID: Process Job ID (A)
- PRCMDNAME: Process Command Name (A)
- CPNAME: Command Parameter Name (A)
- CPVAL: Command Parameter Value (any format)
```

#### **S16F6 - Process Job Cmd Ack** {#s16f6---process-job-cmd-ack}
```

{L[2]
  PRJOBID
  {L[2]
    ACKA
    {L[n]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}

```
```

- PRJOBID: Process Job ID (A)
- ACKA: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)
```

#### **S16F7 - Process Job Alert Notify** {#s16f7---process-job-alert-notify}
```

{L[4]
  TIMESTAMP
  PRJOBID
  PRJOBMILESTONE
  {L[2]
    ACKA
    {L[n]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}

```
```

- TIMESTAMP: Timestamp (A)
- PRJOBID: Process Job ID (A)
- PRJOBMILESTONE: Process Job Milestone (A)
- ACKA: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
- ERRCODE: Error Code (U1, U2, U4, or A)
- ERRTEXT: Error Text (A)
```

#### **S16F8 - Process Job Alert Ack** {#s16f8---process-job-alert-ack}
```

{}

```
```

- No parameters required
```

#### **S16F9 - Process Job Event Notify** {#s16f9---process-job-event-notify}
```

{L[4]
  PREVENTID
  TIMESTAMP
  PRJOBID
  {L[n]
    {L[2]
      VID
      V
    }
  }
}

```
```

- PREVENTID: Process Event ID (A)
- TIMESTAMP: Timestamp (A)
- PRJOBID: Process Job ID (A)
- VID: Variable ID (U1, U2, U4, or A)
- V: Variable Value (any format)
```

#### **S16F10 - Process Job Event Ack** {#s16f10---process-job-event-ack}
```

{}

```
```

- No parameters required
```

#### **S16F11 - Recipe Upload Send** {#s16f11---recipe-upload-send}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F12 - Recipe Upload Acknowledge** {#s16f12---recipe-upload-acknowledge}
```

{L[2]
  EQUIPMENTID
  ACKC16
}

```
```

- EQUIPMENTID: Equipment ID (A)
- ACKC16: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid recipe type
  - 3: Equipment not found
```

#### **S16F13 - Recipe Download Request** {#s16f13---recipe-download-request}
```

{L[2]
  EQUIPMENTID
  RECIPETYPE
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
```

#### **S16F14 - Recipe Download Response** {#s16f14---recipe-download-response}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F15 - Recipe Download Send** {#s16f15---recipe-download-send}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F16 - Recipe Download Acknowledge** {#s16f16---recipe-download-acknowledge}
```

{L[2]
  EQUIPMENTID
  ACKC16
}

```
```

- EQUIPMENTID: Equipment ID (A)
- ACKC16: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid recipe type
  - 3: Equipment not found
```

#### **S16F17 - Recipe Validate Request** {#s16f17---recipe-validate-request}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F18 - Recipe Validate Response** {#s16f18---recipe-validate-response}
```

{L[3]
  EQUIPMENTID
  VALRESULT
  {L[n]
    ERROR_1
    ERROR_2
    ...
    ERROR_n
  }
}

```
```

- EQUIPMENTID: Equipment ID (A)
- VALRESULT: Validation Result (B[1])
  - 0: Valid
  - 1: Invalid
- ERROR: Validation Error (A)
```

#### **S16F19 - Recipe Validate Send** {#s16f19---recipe-validate-send}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F20 - Recipe Validate Acknowledge** {#s16f20---recipe-validate-acknowledge}
```

{L[2]
  EQUIPMENTID
  ACKC16
}

```
```

- EQUIPMENTID: Equipment ID (A)
- ACKC16: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid recipe type
  - 3: Equipment not found
```

#### **S16F21 - Recipe Compress Request** {#s16f21---recipe-compress-request}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F22 - Recipe Compress Response** {#s16f22---recipe-compress-response}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  COMPRESSEDDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- COMPRESSEDDATA: Compressed Data (B)
```

#### **S16F23 - Recipe Compress Send** {#s16f23---recipe-compress-send}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  COMPRESSEDDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- COMPRESSEDDATA: Compressed Data (B)
```

#### **S16F24 - Recipe Compress Acknowledge** {#s16f24---recipe-compress-acknowledge}
```

{L[2]
  EQUIPMENTID
  ACKC16
}

```
```

- EQUIPMENTID: Equipment ID (A)
- ACKC16: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid recipe type
  - 3: Equipment not found
```

#### **S16F25 - Recipe Encrypt Request** {#s16f25---recipe-encrypt-request}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- RECIPEDATA: Recipe Data (any format)
```

#### **S16F26 - Recipe Encrypt Response** {#s16f26---recipe-encrypt-response}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  ENCRYPTEDDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- ENCRYPTEDDATA: Encrypted Data (B)
```

#### **S16F27 - Recipe Encrypt Send** {#s16f27---recipe-encrypt-send}
```

{L[3]
  EQUIPMENTID
  RECIPETYPE
  ENCRYPTEDDATA
}

```
```

- EQUIPMENTID: Equipment ID (A)
- RECIPETYPE: Recipe Type (U1)
- ENCRYPTEDDATA: Encrypted Data (B)
```

#### **S16F28 - Recipe Encrypt Acknowledge** {#s16f28---recipe-encrypt-acknowledge}
```

{L[2]
  EQUIPMENTID
  ACKC16
}

```
```

- EQUIPMENTID: Equipment ID (A)
- ACKC16: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid recipe type
  - 3: Equipment not found
```

#### **S16F29 - PRSetMtrlOrder** {#s16f29---prsetmtrlorder}
```

PRMTRLORDER

```
```

- PRMTRLORDER: Process Material Order (U2)
```

#### **S16F30 - PRSetMtrlOrder Ack** {#s16f30---prsetmtrlorder-ack}
```

ACKA

```
```
- ACKA: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid material order
  - 3: Process not found
```

### Stream 17: Data Report Management
**Purpose**: Data report and trace management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S17F1](#s17f1---data-report-create-request)   | → Equipment | Data Report Create Request |
| [S17F2](#s17f2---data-report-create-acknowledgment)   | ← Equipment | Data Report Create Acknowledgment |
| [S17F3](#s17f3---data-report-delete-request)   | → Equipment | Data Report Delete Request |
| [S17F4](#s17f4---data-report-delete-acknowledgment)   | ← Equipment | Data Report Delete Acknowledgment |
| [S17F5](#s17f5---trace-create-request)   | → Equipment | Trace Create Request |
| [S17F6](#s17f6---trace-create-acknowledgment)   | ← Equipment | Trace Create Acknowledgment |
| [S17F7](#s17f7---trace-delete-request)   | → Equipment | Trace Delete Request |
| [S17F8](#s17f8---trace-delete-acknowledgment)   | ← Equipment | Trace Delete Acknowledgment |
| [S17F9](#s17f9---collection-event-link-request)   | → Equipment | Collection Event Link Request |
| [S17F10](#s17f10---collection-event-link-acknowledgment)   | ← Equipment | Collection Event Link Acknowledgment |
| [S17F11](#s17f11---collection-event-unlink-request)   | → Equipment | Collection Event Unlink Request |
| [S17F12](#s17f12---collection-event-unlink-acknowledgment)   | ← Equipment | Collection Event Unlink Acknowledgment |
| [S17F13](#s17f13---trace-reset-request)   | → Equipment | Trace Reset Request |
| [S17F14](#s17f14---trace-reset-acknowledgment)   | ← Equipment | Trace Reset Acknowledgment |

#### **S17F1 - Data Report Create Request** {#s17f1---data-report-create-request}
```

{L[4]
  DATAID
  RPTID
  DATASRC
  {L[n]
    VID
  }
}

```
```

- DATAID: Data ID (U4)
- RPTID: Report ID (U4)
- DATASRC: Data Source (A)
- VID: Variable ID (U4)
```

#### **S17F2 - Data Report Create Acknowledgment** {#s17f2---data-report-create-acknowledgment}
```

{L[2]
  RPTID
  ERRCODE
}

```
```

- RPTID: Report ID (U4)
- ERRCODE: Error Code (U4)
```

#### **S17F3 - Data Report Delete Request** {#s17f3---data-report-delete-request}
```

{L[n]
  RPTID
}

```
```

- RPTID: Report ID (U4)
- Comment: L:0 means delete all reports
```

#### **S17F4 - Data Report Delete Acknowledgment** {#s17f4---data-report-delete-acknowledgment}
```

{L[2]
  ACKA
  {L[n]
    {L[3]
      RPTID
      ERRCODE
      ERRTEXT
    }
  }
}

```
```

- ACKA: Acknowledge Code (U4)
- RPTID: Report ID (U4)
- ERRCODE: Error Code (U4)
- ERRTEXT: Error Text (A)
```

#### **S17F5 - Trace Create Request** {#s17f5---trace-create-request}
```

{L:6
  DATAID
  TRID
  CEED
  {L[n]
    RPTID
  }
  {L[8]
    TOTSMP
    REPGSZ
    EVNTSRC
    CEIDSTART
    EVNTSRC2
    CEIDSTOP
    TRAUTOD
    RPTOC
  }
}

```
```

- DATAID: Data ID (U4)
- TRID: Trace ID (U4)
- CEED: Collection Event Enable/Disable (B[1])
- RPTID: Report ID (U4)
- TOTSMP: Total Samples (U4)
- REPGSZ: Report Group Size (U4)
- EVNTSRC: Event Source (A)
- CEIDSTART: Collection Event ID Start (U4)
- EVNTSRC2: Event Source 2 (A)
- CEIDSTOP: Collection Event ID Stop (U4)
- TRAUTOD: Trace Auto Delete (B[1])
- RPTOC: Report On Change (B[1])
- Comment: We recommend the host always provides the L:8 values
```

#### **S17F6 - Trace Create Acknowledgment** {#s17f6---trace-create-acknowledgment}
```

{L[2]
  TRID
  ERRCODE
}

```
```

- TRID: Trace ID (U4)
- ERRCODE: Error Code (U4)
```

#### **S17F7 - Trace Delete Request** {#s17f7---trace-delete-request}
```

{L[n]
  TRID
}

```
```

- TRID: Trace ID (U4)
- Comment: Surprisingly, L:0 is not specified as a means to indicate all, but this feature has to be provided because there is no means to discover the existing traces.
```

#### **S17F8 - Trace Delete Acknowledgment** {#s17f8---trace-delete-acknowledgment}
```

{L[2]
  ACKA
  {L[n]
    {L[3]
      TRID
      ERRCODE
      ERRTEXT
    }
  }
}

```
```

- ACKA: Acknowledge Code (U4)
- TRID: Trace ID (U4)
- ERRCODE: Error Code (U4)
- ERRTEXT: Error Text (A)
```

#### **S17F9 - Collection Event Link Request** {#s17f9---collection-event-link-request}
```

{L[4]
  DATAID
  EVNTSRC
  CEID
  {L[n]
    RPTID
  }
}

```
```

- DATAID: Data ID (U4)
- EVNTSRC: Event Source (A)
- CEID: Collection Event ID (U4)
- RPTID: Report ID (U4)
```

#### **S17F10 - Collection Event Link Acknowledgment** {#s17f10---collection-event-link-acknowledgment}
```

{L[3]
  EVNTSRC
  CEID
  ERRCODE
}

```
```

- EVNTSRC: Event Source (A)
- CEID: Collection Event ID (U4)
- ERRCODE: Error Code (U4)
```

#### **S17F11 - Collection Event Unlink Request** {#s17f11---collection-event-unlink-request}
```

{L[3]
  EVNTSRC
  CEID
  RPTID
}

```
```

- EVNTSRC: Event Source (A)
- CEID: Collection Event ID (U4)
- RPTID: Report ID (U4)
```

#### **S17F12 - Collection Event Unlink Acknowledgment** {#s17f12---collection-event-unlink-acknowledgment}
```

{L[4]
  EVNTSRC
  CEID
  RPTID
  ERRCODE
}

```
```

- EVNTSRC: Event Source (A)
- CEID: Collection Event ID (U4)
- RPTID: Report ID (U4)
- ERRCODE: Error Code (U4)
```

#### **S17F13 - Trace Reset Request** {#s17f13---trace-reset-request}
```

{L[n]
TRID
}

```
```

- TRID: Trace ID (U4)
```

#### **S17F14 - Trace Reset Acknowledgment** {#s17f14---trace-reset-acknowledgment}
```

{L[2]
  ACKA
  {L[n]
    {L[3]
      TRID
      ERRCODE
      ERRTEXT
    }
  }
}

```
```

- ACKA: Acknowledge Code (U4)
- TRID: Trace ID (U4)
- ERRCODE: Error Code (U4)
- ERRTEXT: Error Text (A)
```

### Stream 18: Subsystem Management
**Purpose**: Subsystem attribute and data management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S18F1](#s18f1---read-attribute-request)   | → Equipment | Read Attribute Request |
| [S18F2](#s18f2---read-attribute-data)   | ← Equipment | Read Attribute Data |
| [S18F3](#s18f3---write-attribute-request)   | → Equipment | Write Attribute Request |
| [S18F4](#s18f4---write-attribute-acknowledgment)   | ← Equipment | Write Attribute Acknowledgment |
| [S18F5](#s18f5---read-request)   | → Equipment | Read Request |
| [S18F6](#s18f6---read-data)   | ← Equipment | Read Data |
| [S18F7](#s18f7---write-data-request)   | → Equipment | Write Data Request |
| [S18F8](#s18f8---write-data-acknowledgment)   | ← Equipment | Write Data Acknowledgment |
| [S18F9](#s18f9---read-id-request)   | → Equipment | Read ID Request |
| [S18F10](#s18f10---read-id-data)   | ← Equipment | Read ID Data |
| [S18F11](#s18f11---write-id-request)   | → Equipment | Write ID Request |
| [S18F12](#s18f12---write-id-acknowledgment)   | ← Equipment | Write ID Acknowledgment |
| [S18F13](#s18f13---subsystem-command)   | → Equipment | Subsystem Command |
| [S18F14](#s18f14---subsystem-command-acknowledgment)   | ← Equipment | Subsystem Command Acknowledgment |
| [S18F15](#s18f15---read-2d-code-condition-request)   | → Equipment | Read 2D Code Condition Request |
| [S18F16](#s18f16---read-2d-code-condition-data)   | ← Equipment | Read 2D Code Condition Data |

#### **S18F1 - Read Attribute Request** {#s18f1---read-attribute-request}
```

{L[2]
  TARGETID
  {L[n]
    ATTRID
  }
}

```
```

- TARGETID: Target ID (A)
- ATTRID: Attribute ID (A)
```

#### **S18F2 - Read Attribute Data** {#s18f2---read-attribute-data}
```

{L[4]
  TARGETID
  SSACK
  {L[n]
    ATTRDATA
  }
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- ATTRDATA: Attribute Data (any format)
- STATUS: Status (A)
- Comment: E5 differs from OEM tools
```

#### **S18F3 - Write Attribute Request** {#s18f3---write-attribute-request}
```

{L[2]
  TARGETID
  {L[n]
    {L[2]
      ATTRID
      ATTRDATA
    }
  }
}

```
```

- TARGETID: Target ID (A)
- ATTRID: Attribute ID (A)
- ATTRDATA: Attribute Data (any format)
```

#### **S18F4 - Write Attribute Acknowledgment** {#s18f4---write-attribute-acknowledgment}
```

{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- STATUS: Status (A)
- Comment: Fixed E5 mistake
```

#### **S18F5 - Read Request** {#s18f5---read-request}
```

{L[3]
  TARGETID
  DATASEG
  DATALENGTH
}

```
```

- TARGETID: Target ID (A)
- DATASEG: Data Segment (A)
- DATALENGTH: Data Length (U4)
```

#### **S18F6 - Read Data** {#s18f6---read-data}
```

{L[4]
  TARGETID
  SSACK
  DATA
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- DATA: Data (any format)
- STATUS: Status (A)
```

#### **S18F7 - Write Data Request** {#s18f7---write-data-request}
```

{L[4]
  TARGETID
  DATASEG
  DATALENGTH
  DATA
}

```
```

- TARGETID: Target ID (A)
- DATASEG: Data Segment (A)
- DATALENGTH: Data Length (U4)
- DATA: Data (any format)
```

#### **S18F8 - Write Data Acknowledgment** {#s18f8---write-data-acknowledgment}
```

{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- STATUS: Status (A)
```

#### **S18F9 - Read ID Request** {#s18f9---read-id-request}
```

TARGETID

```
```

- TARGETID: Target ID (A)
```

#### **S18F10 - Read ID Data** {#s18f10---read-id-data}
```

{L[4]
  TARGETID
  SSACK
  MID
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- MID: Module ID (A)
- STATUS: Status (A)
```

#### **S18F11 - Write ID Request** {#s18f11---write-id-request}
```

{L[2]
  TARGETID
  MID
}

```
```

- TARGETID: Target ID (A)
- MID: Module ID (A)
```

#### **S18F12 - Write ID Acknowledgment** {#s18f12---write-id-acknowledgment}
```

{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- STATUS: Status (A)
```

#### **S18F13 - Subsystem Command** {#s18f13---subsystem-command}
```

{L[3]
  TARGETID
  SSCMD
  {L[n]
    CPVAL
  }
}

```
```

- TARGETID: Target ID (A)
- SSCMD: Subsystem Command (A)
- CPVAL: Command Parameter Value (any format)
```

#### **S18F14 - Subsystem Command Acknowledgment** {#s18f14---subsystem-command-acknowledgment}
```

{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- STATUS: Status (A)
```

#### **S18F15 - Read 2D Code Condition Request** {#s18f15---read-2d-code-condition-request}
```

TARGETID

```
```

- TARGETID: Target ID (A)
```

#### **S18F16 - Read 2D Code Condition Data** {#s18f16---read-2d-code-condition-data}
```

{L[5]
  TARGETID
  SSACK
  MID
  {L[n]
    STATUS
  }
  {L[n]
    CONDITION
  }
}

```
```

- TARGETID: Target ID (A)
- SSACK: Subsystem Acknowledge (U4)
- MID: Module ID (A)
- STATUS: Status (A)
- CONDITION: Condition (A)
```

### Stream 19: Inventory Management
**Purpose**: Equipment and material inventory tracking

| Message | Direction | Description |
|---------|-----------|-------------|
| [S19F1](#s19f1---inventory-request)   | → Equipment | Inventory Request |
| [S19F2](#s19f2---inventory-response)   | ← Equipment | Inventory Response |
| [S19F3](#s19f3---inventory-update)   | → Equipment | Inventory Update |
| [S19F4](#s19f4---inventory-update-response)   | ← Equipment | Inventory Update Response |
| [S19F5](#s19f5---inventory-add-request)   | → Equipment | Inventory Add Request |
| [S19F6](#s19f6---inventory-add-response)   | ← Equipment | Inventory Add Response |
| [S19F7](#s19f7---inventory-remove-request)   | → Equipment | Inventory Remove Request |
| [S19F8](#s19f8---inventory-remove-response)   | ← Equipment | Inventory Remove Response |
| [S19F9](#s19f9---inventory-status-request)   | → Equipment | Inventory Status Request |
| [S19F10](#s19f10---inventory-status-response)  | ← Equipment | Inventory Status Response |
| [S19F11](#s19f11---inventory-move-request)  | → Equipment | Inventory Move Request |
| [S19F12](#s19f12---inventory-move-response)  | ← Equipment | Inventory Move Response |
| [S19F13](#s19f13---inventory-search-request)  | → Equipment | Inventory Search Request |
| [S19F14](#s19f14---inventory-search-response)  | ← Equipment | Inventory Search Response |
| [S19F15](#s19f15---inventory-lock-request)  | → Equipment | Inventory Lock Request |
| [S19F16](#s19f16---inventory-lock-response)  | ← Equipment | Inventory Lock Response |
| [S19F17](#s19f17---inventory-history-request)  | → Equipment | Inventory History Request |
| [S19F18](#s19f18---inventory-history-response)  | ← Equipment | Inventory History Response |
| [S19F19](#s19f19---inventory-audit-request)  | → Equipment | Inventory Audit Request |
| [S19F20](#s19f20---inventory-audit-response)  | ← Equipment | Inventory Audit Response |
#### **S19F1 - Inventory Request** {#s19f1---inventory-request}
```
{L[n]
  INVTYPE_1
  INVTYPE_2
  ...
  INVTYPE_n
}
```

#### **S19F2 - Inventory Response** {#s19f2---inventory-response}
```
{L[n]
  {L[3]
    INVTYPE
    INVID
    INVDATA
  }
}
```

#### **S19F3 - Inventory Update** {#s19f3---inventory-update}
```
{L[3]
  INVTYPE
  INVID
  INVDATA
}
```

#### **S19F4 - Inventory Update Response** {#s19f4---inventory-update-response}
```
{L[2]
  INVID
  ACKC19
}
```

#### **S19F5 - Inventory Add Request** {#s19f5---inventory-add-request}
```
{L[4]
  INVTYPE
  INVID
  INVDATA
  LOCATION
}
```

#### **S19F6 - Inventory Add Response** {#s19f6---inventory-add-response}
```
{L[2]
  INVID
  ACKC19
}
```

#### **S19F7 - Inventory Remove Request** {#s19f7---inventory-remove-request}
```
{L[2]
  INVTYPE
  INVID
}
```

#### **S19F8 - Inventory Remove Response** {#s19f8---inventory-remove-response}
```
{L[2]
  INVID
  ACKC19
}
```

#### **S19F9 - Inventory Status Request** {#s19f9---inventory-status-request}
```
INVID
```

#### **S19F10 - Inventory Status Response** {#s19f10---inventory-status-response}
```
{L[4]
  INVID
  INVSTATUS
  LOCATION
  INVDATA
}
```

#### **S19F11 - Inventory Move Request** {#s19f11---inventory-move-request}
```
{L[3]
  INVID
  SRCLOCATION
  DESTLOCATION
}
```

#### **S19F12 - Inventory Move Response** {#s19f12---inventory-move-response}
```
{L[2]
  INVID
  ACKC19
}
```

#### **S19F13 - Inventory Search Request** {#s19f13---inventory-search-request}
```
{L[n]
  SEARCHCRITERIA
}
```

#### **S19F14 - Inventory Search Response** {#s19f14---inventory-search-response}
```
{L[n]
  {L[3]
    INVID
    LOCATION
    INVDATA
  }
}
```

#### **S19F15 - Inventory Lock Request** {#s19f15---inventory-lock-request}
```
{L[2]
  INVID
  LOCKTYPE
}
```

#### **S19F16 - Inventory Lock Response** {#s19f16---inventory-lock-response}
```
{L[2]
  INVID
  LOCKSTATUS
}
```

#### **S19F17 - Inventory History Request** {#s19f17---inventory-history-request}
```
{L[3]
  INVID
  STARTTIME
  ENDTIME
}
```

#### **S19F18 - Inventory History Response** {#s19f18---inventory-history-response}
```
  {L[n]
    {L[4]
    INVID
    TIMESTAMP
      ACTION
    DETAILS
  }
}
```

#### **S19F19 - Inventory Audit Request** {#s19f19---inventory-audit-request}
```
{L[2]
  AUDITTYPE
  AUDITPARAMS
}
```

#### **S19F20 - Inventory Audit Response** {#s19f20---inventory-audit-response}
```
{L[2]
  AUDITSTATUS
  AUDITRESULTS
}
```


S19F2	PDE Directory Data	Sent by Host and Equipment


Comment: the list of PDEs, and their attributes matching the request
Format:


{L:3
DIRRSPSTAT
STATUSTXT
{L:m
{L:2
UID
{L:n
{L:2
PDEATTRIBUTE
PDEATTRIBUTEVALUE
}
}
}
}
}


S19F3R	PDE Delete Request	Sent by Host Only


Comment: L:0 is not allowed. Surprisingly the command is only defined for the host despite S19F1R being for both.
Format:


{L:n
UID
}


S19F4	PDE Delete Acknowledge	Sent by Equipment Only


Comment: Surprisingly L:0 is specified as the reply for L:0 input instead of S9F7.
Format:


{L:n
{L:3
UID
DELRSPSTAT
STATUSTXT
}
}


S19F5R	PDE Header Data Request	Sent by Host and Equipment


Comment: n = 0 is not allowed
Format:


{L:n
UID
}


S19F6	PDE Header Data Reply	Sent by Host and Equipment


Comment: A zero length TCID is sent if there are no code 0 PDEs. If L:0 S19F5R input then n=0 reply instead of S9F7!
Format:


{L:2
TCID
{L:n
{L:3
UID
GETRSPSTAT
STATUSTXT
}
}
}


S19F7R	request the transfer of PDEs via Stream 13	Sent by Host and Equipment


Comment: n = 0 is not allowed
Format:


{L:n
UID
}


S19F8	PDE Transfer Reply	Sent by Host and Equipment


Comment: Each PDE data set with the GETRSPSTAT response code of 0 will be sent in a Stream 13 TransferContainer. A zero length TCID is sent if there are no code 0 PDEs. If L:0 S19F7R input then n=0 reply instead of S9F7!
Format:


{L:2
TCID
{L:n
{L:3
UID
GETRSPSTAT
STATUSTXT
}
}
}


S19F9R	Request to Send PDE	Sent by Host and Equipment


Comment: Request permission to initiate PDE transfer using S19F11R.
Format:


{L:2
TCID
TRANSFERSIZE
}


S19F10	Initiate PDE transfer Reply	Sent by Host and Equipment


Format:

{L:3
TCID
RTSRSPSTAT
STATUSTXT
}


S19F11R	Send PDE	Sent by Host and Equipment


Comment: tells the receiver to initiate a Stream 13 transfer with the DSNAME = TCID
Format:


TCID


S19F12	Send PDE Acknowledge	Sent by Host and Equipment


Comment: Header only. The transfer result status is sent in S19F13.
Format:


header only


S19F13R	TransferContainer Report	Sent by Host and Equipment


Comment: Acknowledges the receipt of a TransferContainer using S13. Verification of transferred PDEs is rrequired when received by equipment.
Format:


{L:n
{L:4
UID
SENDRSPSTAT
VERIFYRSPSTAT
STATUSTXT
}
}


S19F14	TransferContainer Report Ack	Sent by Host and Equipment


Comment: header only acknowledges the receipt S19F13R
Format:


header only


S19F15R	Request PDE Resolution	Sent by Host Only


Comment: Request the equipment to resolve PDEs in the target. n can be 0 for no InputMap
Format:


{L:2
TARGETPDE
{L:n
{L:2
PDEREF
RESOLUTION
}
}
}


S19F16	PDE Resolution Data	Sent by Equipment Only


Comment: The output map of the recipe structure. L:m has resolved PDEREF. n can be 0, n >= m
Format:


{L:2
{L:m
{L:2
PDEREF
RESOLUTION
}
}
{L:n
{L:3
UID
RESPDESTAT
STATUSTXT
}
}
}


S19F17R	Verify PDE Request	Sent by Host Only


Comment: n can be 0 when there is no InputMap
Format:


{L:4
TARGETPDE
{L:n
{L:2
PDEREF
RESOLUTION
}
}
VERIFYTYPE
VERIFYDEPTH
}


S19F18	PDE Verification Result	Sent by Equipment Only


Format:

{L:2
VERIFYSUCCESS
{L:n
{L:3
UID
VERIFYRSPSTAT
STATUSTXT
}
}
}


S19F19R	S19 Multi-block Inquire	Sent by Host and Equipment


Comment: SECS-I request permission to send multi-block S19F1,3,5,6,13,15,17. Not required for HSMS.
Format:


DATALENGTH


S19F20	S19 Multi-block Grant	Sent by Host and Equipment


Comment: Usage is not required by the standard. Should not have been included in the standard.
Format:


GRANT



### Stream 20: Substrate Transfer (SEMI-E157)
**Purpose**: Advanced substrate transfer operations

| Message | Direction | Description |
|---------|-----------|-------------|
| [S20F1](#s20f1---transfer-request)   | → Equipment | Transfer Request |
| [S20F2](#s20f2---transfer-response)   | ← Equipment | Transfer Response |
| [S20F3](#s20f3---transfer-pause)   | → Equipment | Transfer Pause |
| [S20F4](#s20f4---transfer-pause-response)   | ← Equipment | Transfer Pause Response |
| [S20F5](#s20f5---transfer-resume)   | → Equipment | Transfer Resume |
| [S20F6](#s20f6---transfer-resume-response)   | ← Equipment | Transfer Resume Response |
| [S20F7](#s20f7---transfer-abort)   | → Equipment | Transfer Abort |
| [S20F8](#s20f8---transfer-abort-response)   | ← Equipment | Transfer Abort Response |
| [S20F9](#s20f9---transfer-status)   | → Equipment | Transfer Status |
| [S20F10](#s20f10---transfer-resume-response)  | ← Equipment | Transfer Resume Response |
| [S20F11](#s20f11---transfer-queue-request)  | → Equipment | Transfer Queue Request |
| [S20F12](#s20f12---transfer-queue-response)  | ← Equipment | Transfer Queue Response |
| [S20F13](#s20f13---transfer-priority-request)  | → Equipment | Transfer Priority Request |
| [S20F14](#s20f14---transfer-priority-response)  | ← Equipment | Transfer Priority Response |
| [S20F15](#s20f15---transfer-route-request)  | → Equipment | Transfer Route Request |
| [S20F16](#s20f16---transfer-route-response)  | ← Equipment | Transfer Route Response |
| [S20F17](#s20f17---transfer-schedule-request)  | → Equipment | Transfer Schedule Request |
| [S20F18](#s20f18---transfer-schedule-response)  | ← Equipment | Transfer Schedule Response |
| [S20F19](#s20f19---transfer-log-request)  | → Equipment | Transfer Log Request |


#### **S20F1 - SetSRO Attributes Request** {#s20f1---setsro-attributes-request}
```
{L[6]
  OBJID
  OBJTYPE
  AUTOPOST_DISABLE
  AUTOCLEAR_DISABLE
  RETAINRECIPE_DISABLE
  AUTOCLOSE
}
```
 

#### **S20F2 - SetSRO Attributes Acknowledge** {#s20f2---setsro-attributes-acknowledge}
```
SSAACK
```


#### **S20F3 - GetOperationIDList Request** {#s20f3---getoperationidlist-request}
```
{L[3]
  OBJID
  OBJTYPE
  OPETYPE
}
```


#### **S20F4 - GetOperationIDList Acknowledge** {#s20f4---getoperationidlist-acknowledge}
```
{L[2]
  {L[n]
    OPEID
  }
  GOILACK
}
```


#### **S20F5 - OpenConnectionEvent Send** {#s20f5---openconnectionevent-send}
```
{L[7]
  OBJID
  OBJTYPE
  OPETYPE
  RMSUSERID
  RMSPWD
  EQUSERID
  OPEID
}
```


#### **S20F6 - OpenConnectionEvent Acknowledge** {#s20f6---openconnectionevent-acknowledge}
```
{L[2]
  OPEID
  OCEACK
}
```


#### **S20F7 - CloseConnectionEvent Send** {#s20f7---closeconnectionevent-send}
```
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F8 - CloseConnectionEvent Acknowledge** {#s20f8---closeconnectionevent-acknowledge}
```
{L[2]
  OPEID
  CCEACK
}
```


#### **S20F9 - ClearOperation Request** {#s20f9---clearoperation-request}
```
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F10 - ClearOperation Acknowledge** {#s20f10---clearoperation-acknowledge}
```
COACK
```


#### **S20F11 - GetRecipeXIDList Request** {#s20f11---getrecipexidlist-request}
```
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F12 - GetRecipeXIDList Acknowledge** {#s20f12---getrecipexidlist-acknowledge}
```
{L[2]
{L[n]
    {L[9]
    TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
    }
  }
  GRXLACK
}
```


#### **S20F13 - DeleteRecipe Request** {#s20f13---deleterecipe-request}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  {L[9]
    TIMESTAMP
    OPEID
    ASSGNID
    COPYID
    REVID
    RecID
    VERID
    TYPEID
    EQID
  }
}
```


#### **S20F14 - DeleteRecipe Acknowledge** {#s20f14---deleterecipe-acknowledge}
```
DRRACK
```


#### **S20F15 - WriteRecipe Request** {#s20f15---writerecipe-request}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
{L[n]
    {L[10]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
      RCPBODYA
    }
  }
}
```


#### **S20F16 - WriteRecipe Acknowledge** {#s20f16---writerecipe-acknowledge}
```
WRACK
```


#### **S20F17 - ReadRecipe Request** {#s20f17---readrecipe-request}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
{L[n]
    {L[9]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
    }
  }
}
```


#### **S20F18 - ReadRecipe Acknowledge** {#s20f18---readrecipe-acknowledge}
```
{L[2]
  {L[n]
    {L[10]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
      RCPBODYA
    }
  }
  RRACK_S20
}
```


#### **S20F19 - QueryRecipeXIDList Event Send** {#s20f19---queryrecipexidlist-event-send}
```
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F20 - QueryRecipeXIDList Event Acknowledge** {#s20f20---queryrecipexidlist-event-acknowledge}
```
{L[3]
  OPEID
  {L[n]
    {L[9]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
    }
  }
  QRXLEACK
}
```


#### **S20F21 - QueryRecipe Event Send** {#s20f21---queryrecipe-event-send}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  {L[n]
    {L[9]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
    }
  }
}
```


#### **S20F22 - QueryRecipe Event Acknowledge** {#s20f22---queryrecipe-event-acknowledge}
```
QREACK
```


#### **S20F23 - PostRecipe Event Send** {#s20f23---postrecipe-event-send}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  {L[n]
    {L[10]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
      RCPBODYA
    }
  }
}
```


#### **S20F24 - PostRecipe Event Acknowledge** {#s20f24---postrecipe-event-acknowledge}
```
PREACK
```


#### **S20F25 - SetPRC Attributes Request** {#s20f25---setprc-attributes-request}
```
{L[5]
  OBJID
  OBJTYPE
{L[n]
    MAXNUMBER
  }
  MAXTIME
  PRCPREEXECHK
}
```


#### **S20F26 - SetPRC Attributes Acknowledge** {#s20f26---setprc-attributes-acknowledge}
```
SPAACK
```


#### **S20F27 - PreSpecifyRecipe Request** {#s20f27---prespecifyrecipe-request}
```
{L[6]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
  {L[n]
    {L[9]
  TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
    }
  }
}
```


#### **S20F28 - PreSpecifyRecipe Acknowledge** {#s20f28---prespecifyrecipe-acknowledge}
```
PSRACK
```


#### **S20F29 - QueryPJRecipeXIDList Event Send** {#s20f29---querypjrecipexidlist-event-send}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
}
```


#### **S20F30 - QueryPJRecipeXIDList Event Acknowledge** {#s20f30---querypjrecipexidlist-event-acknowledge}
```
{L[2]
  {L[n]
    {L[9]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
    }
  }
  QPRKEACK
}
```


#### **S20F31 - Pre-Exe Check Event Send** {#s20f31---pre-exe-check-event-send}
```
{L[6]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
  CHKINFO
}
```


#### **S20F32 - Pre-Exe Check Event Acknowledge** {#s20f32---pre-exe-check-event-acknowledge}
```
{L[3]
  PECRSLT
  {L[n]
    {L[10]
      TIMESTAMP
      OPEID
      ASSGNID
      COPYID
      REVID
      RecID
      VERID
      TYPEID
      EQID
      RCPBODYA
    }
  }
  PECEACK
}
```


#### **S20F33 - PreSpecifyRecipe Event Send** {#s20f33---prespecifyrecipe-event-send}
```
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
}
```


#### **S20F34 - PreSpecifyRecipe Event Acknowledge** {#s20f34---prespecifyrecipe-event-acknowledge}
```
PSREACK
```



### Stream 21: Material Transfer Management
**Purpose**: High-level material transfer coordination

| Message | Direction | Description |
|---------|-----------|-------------|
| [S21F1](#s21f1---material-transfer-plan)   | → Equipment | Material Transfer Plan |
| [S21F2](#s21f2---material-transfer-plan-response)   | ← Equipment | Material Transfer Plan Response |
#### **S21F1 - Material Transfer Plan** {#s21f1---material-transfer-plan}
```
{L[4]
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
}
```

#### **S21F2 - Material Transfer Plan Response** {#s21f2---material-transfer-plan-response}
```
{L[2]
  ITEMACK
  ITEMERROR
}
```


#### **S21F2 - Item Load Grant** {#s21f2---item-load-grant}
```
{L[2]
  ITEMACK
  ITEMERROR
}
```


#### **S21F3 - Item Send** {#s21f3---item-send}
```
  {L[5]
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
  {L[n]
    ITEMPART
  }
}
```


#### **S21F4 - Item Send Acknowledge** {#s21f4---item-send-acknowledge}
```
{L[2]
  ITEMACK
  ITEMERROR
}
```


#### **S21F5 - Item Request** {#s21f5---item-request}
```
{L[2]
  ITEMTYPE
  ITEMID
}
```


#### **S21F6 - Item Data** {#s21f6---item-data}
```
{L[7]
  ITEMACK
  ITEMERROR
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
  {L[n]
    ITEMPART
  }
}
```


#### **S21F7 - Item Type List Request** {#s21f7---item-type-list-request}
```
ITEMTYPE
```


#### **S21F8 - Item Type List Results** {#s21f8---item-type-list-results}
```
{L[7]
  ITEMACK
  ITEMERROR
  ITEMTYPE
{L[n]
    {L[3]
      ITEMID
      ITEMLENGTH
      ITEMVERSION
    }
  }
}
```


#### **S21F9 - Supported Item Type List Request** {#s21f9---supported-item-type-list-request}
```
header only
```


#### **S21F10 - Supported Item Type List Result** {#s21f10---supported-item-type-list-result}
```
{L[3]
  ITEMACK
  ITEMERROR
  {L[n]
    ITEMTYPE
  }
}
```


#### **S21F11 - Item Delete** {#s21f11---item-delete}
```
{L[2]
  ITEMTYPE
  {L[n]
    ITEMID
  }
}
```


#### **S21F12 - Item Delete Acknowledge** {#s21f12---item-delete-acknowledge}
```
{L[3]
  ITEMACK
  ITEMTYPE
  {L[n]
    {L[3]
      ITEMID
      ITEMACK
      ITEMERROR
    }
  }
}
```


#### **S21F13 - Request Permission To Send Item** {#s21f13---request-permission-to-send-item}
```
{L[5]
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
  ITEMPARTCOUNT
}
```


#### **S21F14 - Grant Permission To Send Item** {#s21f14---grant-permission-to-send-item}
```
{L[2]
  ITEMACK
  ITEMERROR
}
```


#### **S21F15 - Item Request** {#s21f15---item-request}
```
{L[2]
  ITEMTYPE
  ITEMID
}
```


#### **S21F16 - Item Request Grant** {#s21f16---item-request-grant}
```
{L[7]
  ITEMACK
  ITEMERROR
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
  ITEMPARTCOUNT
}
```


#### **S21F17 - Send Item Part** {#s21f17---send-item-part}
```
{L[8]
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
  ITEMINDEX
  ITEMPARTCOUNT
  ITEMPARTLENGTH
  ITEMPART
}
```


#### **S21F18 - Send Item Part Acknowledge** {#s21f18---send-item-part-acknowledge}
```
{L[2]
  ITEMACK
  ITEMERROR
}
```


#### **S21F19 - Item Type Feature Support** {#s21f19---item-type-feature-support}
```
{L[n]
  ITEMTYPE
}
```


#### **S21F20 - Item Type Feature Support Results** {#s21f20---item-type-feature-support-results}
```
{L[n]
  {L[4]
    ITEMACK
    ITEMERROR
    ITEMTYPE
    ITEMTYPESUPPORT
  }
}
```



## Message Categories

### Equipment Status (Stream 1)
- Basic communication establishment
- Equipment state monitoring
- Online/Offline control

### Equipment Control (Stream 2)
- Configuration management
- Time synchronization
- Event reporting setup

### Material Management (Streams 3-4)
- Carrier and substrate tracking
- Transfer job management
- Material handling control

### Exception Handling (Stream 5)
- Alarm management
- Exception reporting
- Error notification

### Data Collection (Stream 6)
- Process data gathering
- Event monitoring
- Trace data collection

### Program Management (Stream 7)
- Recipe management
- Process program control
- EPPD handling

### System Services (Streams 9-10)
- Error reporting
- Terminal communication
- System diagnostics

### Advanced Features (Streams 12+)
- Wafer mapping
- Object services
- Recipe management
- Processing control

## Common Message Examples

### S1F13 - Establish Communications Request
```
Hex 
Length: 00 00 00 0C (12 bytes)
Header: 00 00 81 0D 00 00 xx xx xx xx
Data:   01 00 (empty list)

SECS-II 
{L:0}  // Empty list
```

### S1F14 - Establish Communications Response
```
Hex 
Length: 00 00 00 0D (13 bytes)  
Header: 00 00 01 0E 00 00 xx xx xx xx
Data:   21 01 00 (COMMACK = 0, accepted)

SECS-II 
COMMACK = B[1] = 0  // Communication accepted

Or with model info:
{L[2]
  COMMACK = B[1] = 0
  {L[2]
    MDLN = A[20] = "EQUIPMENT_MODEL_NAME"
    SOFTREV = A[20] = "SOFTWARE_VERSION_1.0"
  }
}
```

### S1F1 - Are You There Request
```
Hex 
Length: 00 00 00 0A (10 bytes)
Header: 00 00 81 01 00 00 xx xx xx xx
Data:   (empty)

SECS-II 
<none> (no data)
```

### S1F2 - Are You There Response  
```
Hex 
Length: 00 00 00 0A (10 bytes)
Header: 00 00 01 02 00 00 xx xx xx xx
Data:   (empty)

SECS-II 
<none> (no data) or {L:0} (empty list)
```

### S5F1 - Alarm Report Example
```
Hex 
Length: 00 00 00 1F (31 bytes)
Header: 00 00 05 01 00 00 xx xx xx xx
Data:   01 03 81 01 81 A1 01 01 41 0F Temperature Alarm

SECS-II 
{L[3]
  ALCD = B[1] = 129 (0x81) // Alarm Set + Alarm Type
  ALID = U1[1] = 1
  ALTX = A[15] = "Temperature Alarm"
}
```

### S6F11 - Event Report Example
```
SECS-II 
{L[3]
  DATAID = U4[1] = 12345
  CEID = U2[1] = 1001
  {L:1
    {L[3]
      RPTID = U2[1] = 2001
      {L[2]
        Temperature = F4[1] = 25.5
        Pressure = F4[1] = 760.0
      }
    }
  }
}
```

### Data Type Format Examples
```
ASCII Text:    A[10] = "TEST_VALUE"
                Hex: 41 0A 54 45 53 54 5F 56 41 4C 55 45

Binary Data:   B[4] = 0x12345678
                Hex: 21 04 12 34 56 78

Unsigned Int:  U1[1] = 255
                Hex: F1 01 FF

               U2[1] = 65535
                Hex: E1 02 FF FF

               U4[1] = 4294967295

## SECS Data Item Definitions

This section provides definitions for all standard SECS data items used in message formats.

### A

**ABS** - Absolute Position (F4, F8)
- Absolute position coordinate

**ACCESSMODE** - Access Mode (U1)
- 0: Read only
- 1: Read/Write
- 2: Write only

**ACDS** - Alarm Collection Definition Send (various)
- Alarm collection definition data

**ACKA** - Acknowledge (B[1])
- General acknowledge code

**ACKC10** - Terminal Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error

**ACKC13** - Data Set Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error
- 2: Data set already exists
- 3: No space available

**ACKC15** - Recipe Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error
- 2: Recipe already exists
- 3: No space available

**ACKC3** - Carrier Acknowledge Code (B[1])
- 0: Completed successfully
- 1: Command does not exist
- 2: Cannot perform now
- 3: At least one parameter invalid
- 4: Acknowledge after completion
- 5: Rejected, already in desired condition
- 6: No such object exists

**ACKC5** - Alarm Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error

**ACKC6** - Data Collection Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error

**ACKC7** - Process Program Acknowledge Code (B[1])
- 0: Accepted
- 1: Permission not granted
- 2: Length error
- 3: Matrix overflow
- 4: PPID not found
- 5: Mode unsupported
- 6: Communication not available
- 7: Busy

**ACKC7A** - Alternative Process Program Acknowledge Code (B[1])
- Same as ACKC7 with additional codes

**AGENT** - Agent Identifier (A)
- Software agent identification

**ALCD** - Alarm Code (B[1])
- Bit 0: Alarm Set (1) or Clear (0)
- Bit 7: Alarm (1) or Warning (0)

**ALED** - Alarm Enable/Disable (B[1])
- 128 (0x80): Enable
- 0: Disable

**ALID** - Alarm ID (U1, U2, U4, or A)
- Unique identifier for alarm

**ALIDVECTOR** - Alarm ID Vector (List of ALID)
- Collection of alarm identifiers

**ALTX** - Alarm Text (A[120])
- Descriptive text for alarm

### B-C

**ASSGNID** - Assignment ID (A)
- Unique assignment identifier

**ATTRDATA** - Attribute Data (various)
- Data value for object attribute

**ATTRID** - Attribute ID (U1, U2, U4, or A)
- Identifier for object attribute

**ATTRRELN** - Attribute Relation (U1)
- Relationship type between attributes

**AUTOCLEAR_DISABLE** - Auto Clear Disable (BOOLEAN)
- Disable automatic clearing

**AUTOCLOSE** - Auto Close (BOOLEAN)
- Automatic closing flag

**AUTOPOST_DISABLE** - Auto Post Disable (BOOLEAN)
- Disable automatic posting

**BCDS** - Binary Collection Definition Send (B)
- Binary collection definition data

**BCEQU** - Binary Collection Equipment (B)
- Equipment binary collection data

**BINLT** - Binary Data (B)
- Binary data content

**BLKDEF** - Block Definition (various)
- Definition of data block structure

**BPD** - Bytes Per Die (U2)
- Number of bytes per die

**BYTMAX** - Maximum Bytes (U4)
- Maximum byte count

**CAACK** - Carrier Action Acknowledge (B[1])
- 0: Completed successfully
- 1: Command does not exist
- 2: Cannot perform now
- 3: At least one parameter invalid

**CARRIERACTION** - Carrier Action (U1)
- 1: Load
- 2: Unload
- 3: Transfer
- 4: Map
- 5: Clamp
- 6: Unclamp

**CARRIERID** - Carrier ID (A)
- Unique identifier for carrier

**CARRIERSPEC** - Carrier Specification (various)
- Carrier specification data

**CATTRDATA** - Carrier Attribute Data (various)
- Data for carrier attribute

**CATTRID** - Carrier Attribute ID (U1, U2, U4, or A)
- Identifier for carrier attribute

**CCEACK** - Collection Event Change Acknowledge (B[1])
- Collection event change response

**CCODE** - Command Code (A)
- Command identifier string

**CEED** - Collection Event Enable/Disable (BOOLEAN)
- Enable or disable collection event

**CEID** - Collection Event ID (U1, U2, U4, or A)
- Unique identifier for collection event

**CEIDSTART** - Collection Event ID Start (CEID)
- Starting collection event ID

**CEIDSTOP** - Collection Event ID Stop (CEID)
- Stopping collection event ID

**CENAME** - Collection Event Name (A)
- Name of collection event

**CEPACK** - Collection Event Parameter Acknowledge (B[1])
- Collection event parameter response

**CEPVAL** - Collection Event Parameter Value (various)
- Value of collection event parameter

**CHKINFO** - Check Information (A)
- Information for checking/validation

**CKPNT** - Checkpoint (A)
- Process checkpoint identifier

**CMDA** - Command Acknowledge (B[1])
- Command acknowledgment

**CMDMAX** - Command Maximum (U2)
- Maximum command value

**CNAME** - Collection Name (A)
- Name of data collection

**COACK** - Control Job Command Acknowledge (B[1])
- Control job command response

**COLCT** - Collection Count (U2)
- Number of items in collection

**COLHDR** - Collection Header (various)
- Header information for collection

**COMMACK** - Communication Acknowledge (B[1])
- 0: Accepted
- 1: Denied, Try Again
- 2: Denied, Permission Not Granted

**COMPARISONOPERATOR** - Comparison Operator (U1)
- 0: Equal
- 1: Not equal
- 2: Less than
- 3: Less than or equal
- 4: Greater than
- 5: Greater than or equal

**CONDITION** - Condition (A)
- Condition specification

**COPYID** - Copy ID (A)
- Identifier for copy operation

**CPACK** - Command Parameter Acknowledge (various)
- Command parameter acknowledgment

**CPNAME** - Command Parameter Name (A)
- Name of command parameter

**CPVAL** - Command Parameter Value (various)
- Value of command parameter

### D-E

**CSAACK** - Carrier Slot Assignment Acknowledge (B[1])
- Carrier slot assignment response

**CTLJOBCMD** - Control Job Command (A)
- Control job command string

**CTLJOBID** - Control Job ID (A)
- Unique identifier for control job

**DATA** - Data (various)
- Generic data field

**DATAACK** - Data Acknowledge (B[1])
- Data acknowledgment

**DATAID** - Data ID (U1, U2, U4, or A)
- Unique identifier for data

**DATALENGTH** - Data Length (U1, U2, U4)
- Length of data in bytes

**DATASEG** - Data Segment (B)
- Segment of larger data

**DATASRC** - Data Source (A)
- Source of data

**DATLC** - Data Location (A)
- Location of data

**DELRSPSTAT** - Delete Response Status (B[1])
- Status of delete operation

**DIRRSPSTAT** - Directory Response Status (B[1])
- Status of directory operation

**DRACK** - Define Report Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, Insufficient space
- 2: Denied, Invalid format
- 3: Denied, At least one RPTID already defined
- 4: Denied, At least one VID does not exist

**DRRACK** - Define Report Request Acknowledge (B[1])
- Define report request response

**DSID** - Data Set ID (U1, U2, U4, or A)
- Unique identifier for data set

**DSNAME** - Data Set Name (A)
- Name of data set

**DSPER** - Data Sample Period (U1, U2, U4)
- Sampling period for data collection

**DUTMS** - Device Under Test Milliseconds (U4)
- Time in milliseconds for device test

**DVNAME** - Discrete Variable Name (A)
- Name of discrete variable

**DVVAL** - Discrete Variable Value (various)
- Value of discrete variable

**DVVALNAME** - Discrete Variable Value Name (A)
- Name for discrete variable value

**EAC** - Equipment Acknowledge Code (B[1])
- 0: Accepted
- 1: Denied, At least one constant does not exist
- 2: Denied, Busy
- 3: Denied, At least one constant out of range

**ECDEF** - Equipment Constant Default (various)
- Default value for equipment constant

**ECID** - Equipment Constant ID (U1, U2, U4, or A)
- Unique identifier for equipment constant

**ECMAX** - Equipment Constant Maximum (various)
- Maximum value for equipment constant

**ECMIN** - Equipment Constant Minimum (various)
- Minimum value for equipment constant

**ECNAME** - Equipment Constant Name (A)
- Name of equipment constant

**ECV** - Equipment Constant Value (various)
- Value of equipment constant

**EDID** - Equipment ID (U1, U2, U4, or A)
- Unique identifier for equipment

**EMID** - Equipment Module ID (A)
- Identifier for equipment module

**EPD** - Equipment Parameter Data (various)
- Equipment parameter information

**EQID** - Equipment ID (A)
- Equipment identifier

**EQNAME** - Equipment Name (A)
- Name of equipment

**EQUSERID** - Equipment User ID (A)
- User identifier for equipment access

**ERACK** - Enable/Disable Event Report Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, At least one CEID does not exist
- 2: Denied, Busy

**ERRCODE** - Error Code (U2)
- Numeric error code

**ERRTEXT** - Error Text (A)
- Descriptive error text

**ERRW7** - Error W7 (B[1])
- W7-specific error code

**EVNTSRC** - Event Source (A)
- Source of event

**EVNTSRC2** - Event Source 2 (A)
- Secondary event source

**EXID** - Exception ID (U4)
- Exception identifier

**EXMESSAGE** - Exception Message (A)
- Exception message text

**EXRECVRA** - Exception Recovery Action (A)
- Recovery action for exception

**EXTYPE** - Exception Type (U1)
- Type of exception

### F-L

**FCNID** - Function ID (B[1])
- SECS function identifier

**FFROT** - Flat Finder Rotation (F4)
- Rotation angle for flat finder

**FILDAT** - File Data (B)
- File content data

**FNLOC** - Final Location (A)
- Final destination location

**FRMLEN** - Frame Length (U2)
- Length of data frame

**GETRSPSTAT** - Get Response Status (B[1])
- Status of get operation

**GOILACK** - Go Online Acknowledge (B[1])
- Go online response

**GRANT** - Grant Code (B[1])
- 0: Granted
- 1: Busy, try again
- 2: No space

**GRANT6** - Grant Code 6 (B[1])
- Stream 6 specific grant code

**GRNT1** - Grant 1 (B[1])
- First grant code

**GRXLACK** - Get Recipe Acknowledge (B[1])
- Recipe get acknowledgment

**HANDLE** - Handle (A)
- Object handle identifier

**HCACK** - Host Command Acknowledge (B[1])
- 0: Acknowledged
- 1: Invalid command
- 2: Cannot perform now
- 3: At least one parameter invalid
- 4: Acknowledge after completion
- 5: Rejected, already in desired condition
- 6: No such object exists

**HOACK** - Host Online Acknowledge (B[1])
- Host online acknowledgment

**HOCANCELACK** - Host Online Cancel Acknowledge (B[1])
- Host online cancel response

**HOCMDNAME** - Host Online Command Name (A)
- Name of host online command

**HOHALTACK** - Host Online Halt Acknowledge (B[1])
- Host online halt response

**IACDS** - Input Alarm Collection Definition Send (various)
- Input alarm collection definition

**IBCDS** - Input Binary Collection Definition Send (B)
- Input binary collection definition

**IDTYP** - ID Type (B[1])
- 0: Data ID
- 1: Equipment ID

**INPTN** - Input Pattern (A)
- Input pattern specification

**ITEMACK** - Item Acknowledge (B[1])
- Item operation acknowledgment

**ITEMERROR** - Item Error (A)
- Error information for item

**ITEMID** - Item ID (A)
- Unique identifier for item

**ITEMINDEX** - Item Index (U4)
- Index position of item

**ITEMLENGTH** - Item Length (U4)
- Length of item data

**ITEMPART** - Item Part (various)
- Part of larger item

**ITEMPARTCOUNT** - Item Part Count (U4)
- Number of parts in item

**ITEMPARTLENGTH** - Item Part Length (U4)
- Length of item part

**ITEMTYPE** - Item Type (U1)
- Type classification of item

**ITEMTYPESUPPORT** - Item Type Support (B[1])
- Support indicator for item type

**ITEMVERSION** - Item Version (A)
- Version of item

**JOBACTION** - Job Action (U1)
- Action to perform on job

**LENGTH** - Length (U1, U2, U4)
- Generic length value

**LIMITACK** - Limit Acknowledge (B[1])
- Limit operation acknowledgment

**LIMITID** - Limit ID (A)
- Identifier for limit

**LIMITMAX** - Limit Maximum (various)
- Maximum limit value

**LIMITMIN** - Limit Minimum (various)
- Minimum limit value

**LINKID** - Link ID (A)
- Identifier for link

**LOC** - Location (A)
- General location identifier

**LOCID** - Location ID (A)
- Specific location identifier

**LOWERDB** - Lower Deadband (various)
- Lower deadband value

**LRACK** - Link Report Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, Insufficient space
- 2: Denied, Invalid format
- 3: Denied, At least one CEID already defined
- 4: Denied, At least one CEID does not exist
- 5: Denied, At least one RPTID does not exist

**LVACK** - Limit Value Acknowledge (B[1])
- Limit value acknowledgment

### M-P

**MAPER** - Map Error (U1)
- Map operation error code

**MAPFT** - Map Format (U1)
- Format of map data

**MAXNUMBER** - Maximum Number (U4)
- Maximum numeric value

**MAXTIME** - Maximum Time (U4)
- Maximum time value

**MCINDEX** - Multi-Collection Index (U2)
- Index for multi-collection

**MDACK** - Mode Data Acknowledge (B[1])
- Mode data acknowledgment

**MDLN** - Model Number (A[20])
- Equipment model designation

**MEXP** - Message Expected (B[1])
- Expected message indicator

**MF** - Message Format (U1)
- Format of message

**MHEAD** - Message Header (B[10])
- Complete 10-byte SECS message header

**MID** - Message ID (U1, U2, U4, or A)
- Message identifier

**MIDAC** - Message ID Acknowledge (B[1])
- Message ID acknowledgment

**MIDRA** - Message ID Response Acknowledge (B[1])
- Message ID response acknowledgment

**MLCL** - Multi-Level Collection List (various)
- Multi-level collection data

**MMODE** - Machine Mode (U1)
- Current machine operating mode

**NACDS** - New Alarm Collection Definition Send (various)
- New alarm collection definition

**NBCDS** - New Binary Collection Definition Send (B)
- New binary collection definition

**NULBC** - Null Byte Count (U1)
- Count of null bytes

**OBJACK** - Object Acknowledge (B[1])
- Object operation acknowledgment

**OBJCMD** - Object Command (A)
- Command for object

**OBJID** - Object ID (A)
- Unique identifier for object

**OBJSPEC** - Object Specification (A)
- Object specification string

**OBJTOKEN** - Object Token (A)
- Token for object access

**OBJTYPE** - Object Type (A)
- Type classification of object

**OCEACK** - Object Collection Event Acknowledge (B[1])
- Object collection event response

**OFLACK** - Offline Acknowledge (B[1])
- 0: Offline Accepted
- 1: Offline Not Allowed

**ONLACK** - Online Acknowledge (B[1])
- 0: Online Accepted
- 1: Online Not Allowed

**OPEID** - Operation Event ID (A)
- Identifier for operation event

**OPETYPE** - Operation Event Type (U1)
- Type of operation event

**OPID** - Operation ID (A)
- Unique operation identifier

**ORLOC** - Origin Location (A)
- Origin location identifier

**OUTPTN** - Output Pattern (A)
- Output pattern specification

**PARAMNAME** - Parameter Name (A)
- Name of parameter

**PARAMVAL** - Parameter Value (various)
- Value of parameter

**PDEATTRIBUTE** - Process Data Element Attribute (various)
- Process data element attribute

**PDEATTRIBUTENAME** - Process Data Element Attribute Name (A)
- Name of process data element attribute

**PDEATTRIBUTEVALUE** - Process Data Element Attribute Value (various)
- Value of process data element attribute

**PDEREF** - Process Data Element Reference (A)
- Reference to process data element

**PECEACK** - Process Event Collection Enable Acknowledge (B[1])
- Process event collection enable response

**PECRSLT** - Process Event Collection Result (various)
- Result of process event collection

**PFCD** - Process Function Code (U1)
- Function code for process

**PGRPACTION** - Port Group Action (U1)
- Action for port group

**PODID** - Point of Delivery ID (A)
- Identifier for delivery point

**PORTACTION** - Port Action (U1)
- Action for port

**PORTGRPNAME** - Port Group Name (A)
- Name of port group

**PPARM** - Process Parameter (various)
- Process parameter value

**PPBODY** - Process Program Body (A or B)
- Content of process program

**PPGNT** - Process Program Grant (B[1])
- Process program grant response

**PPID** - Process Program ID (A)
- Unique identifier for process program

**PRAXI** - Process Axis (A)
- Process axis identifier

**PRCMDNAME** - Process Command Name (A)
- Name of process command

**PRCPREEXECHK** - Process Pre-Execution Check (B[1])
- Pre-execution check flag

**PRDCT** - Product (A)
- Product identifier

**PREACK** - Process Recipe Acknowledge (B[1])
- Process recipe acknowledgment

**PREVENTID** - Process Event ID (A)
- Process event identifier

**PRJOBID** - Process Job ID (A)
- Process job identifier

**PRJOBMILESTONE** - Process Job Milestone (A)
- Process job milestone

**PRJOBSPACE** - Process Job Space (A)
- Process job space allocation

**PRMTRLORDER** - Process Material Order (U2)
- Order of process material

**PRPAUSEEVENTID** - Process Pause Event ID (A)
- Event ID for process pause

**PRPROCESSSTART** - Process Process Start (A)
- Process start identifier

**PRRECIPEMETHOD** - Process Recipe Method (A)
- Process recipe method

**PRSTATE** - Process State (U1)
- Current state of process

**PSRACK** - Process Start Request Acknowledge (B[1])
- Process start request response

**PSREACK** - Process State Request Acknowledge (B[1])
- Process state request response

**PTN** - Port Number (U1)
- Port identification number

### Q-Z

**QPRKEACK** - Query Process Recipe Key Acknowledge (B[1])
- Query process recipe key response

**QREACK** - Query Recipe Acknowledge (B[1])
- Query recipe response

**QRXLEACK** - Query Recipe Exclude Acknowledge (B[1])
- Query recipe exclude response

**QUA** - Quality (U1)
- Quality indicator

**RAC** - Report Acknowledge (B[1])
- Report acknowledgment

**RCMD** - Remote Command (A)
- Remote command string

**RCPATTRDATA** - Recipe Attribute Data (various)
- Recipe attribute data

**RCPATTRID** - Recipe Attribute ID (A)
- Recipe attribute identifier

**RCPBODY** - Recipe Body (A or B)
- Recipe content

**RCPBODYA** - Recipe Body A (A)
- Recipe body in ASCII format

**RCPCLASS** - Recipe Class (A)
- Classification of recipe

**RCPCMD** - Recipe Command (A)
- Recipe command

**RCPDEL** - Recipe Delete (A)
- Recipe deletion identifier

**RCPDESCLTH** - Recipe Description Length (U2)
- Length of recipe description

**RCPDESCNM** - Recipe Description Name (A)
- Recipe description name

**RCPDESCTIME** - Recipe Description Time (A)
- Recipe description timestamp

**RCPID** - Recipe ID (A)
- Unique recipe identifier

**RCPNAME** - Recipe Name (A)
- Name of recipe

**RCPNEWID** - Recipe New ID (A)
- New recipe identifier

**RCPOWCODE** - Recipe Owner Code (A)
- Recipe ownership code

**RCPPARNM** - Recipe Parameter Name (A)
- Name of recipe parameter

**RCPPARRULE** - Recipe Parameter Rule (A)
- Rule for recipe parameter

**RCPPARVAL** - Recipe Parameter Value (various)
- Value of recipe parameter

**RCPRENAME** - Recipe Rename (A)
- New name for recipe

**RCPSECCODE** - Recipe Security Code (A)
- Security code for recipe

**RCPSECNM** - Recipe Section Name (A)
- Name of recipe section

**RCPSPEC** - Recipe Specification (A)
- Recipe specification

**RCPSTAT** - Recipe Status (U1)
- Status of recipe

**RCPUPDT** - Recipe Update (A)
- Recipe update identifier

**RCPVERS** - Recipe Version (A)
- Version of recipe

**READLN** - Read Length (U4)
- Length to read

**REAPER** - Report Error (U1)
- Report error code

**RECLEN** - Record Length (U2)
- Length of record

**REFP** - Reference Point (F4, F8)
- Reference coordinate point

**REPGSZ** - Report Group Size (U2)
- Size of report group

**RESOLUTION** - Resolution (F4)
- Measurement resolution

**RESPDESTAT** - Response Delete Status (B[1])
- Status of response deletion

**RESPEC** - Request Specification (A)
- Request specification string

**RETAINRECIPE_DISABLE** - Retain Recipe Disable (BOOLEAN)
- Disable recipe retention

**RETICLEID** - Reticle ID (A)
- Reticle identifier

**RETICLEID2** - Reticle ID 2 (A)
- Secondary reticle identifier

**RETPLACEINSTR** - Reticle Place Instruction (A)
- Instruction for reticle placement

**RETREMOVEINSTR** - Reticle Remove Instruction (A)
- Instruction for reticle removal

**REVID** - Revision ID (A)
- Revision identifier

**RIC** - Report Item Count (U2)
- Count of items in report

**RMACK** - Resource Manager Acknowledge (B[1])
- Resource manager acknowledgment

**RMCHGSTAT** - Resource Manager Change Status (B[1])
- Resource manager change status

**RMCHGTYPE** - Resource Manager Change Type (U1)
- Type of resource manager change

**RMDATASIZE** - Resource Manager Data Size (U4)
- Size of resource manager data

**RMGRNT** - Resource Manager Grant (B[1])
- Resource manager grant

**RMNEWNS** - Resource Manager New Namespace (A)
- New namespace for resource manager

**RMNSCMD** - Resource Manager Namespace Command (A)
- Resource manager namespace command

**RMNSSPEC** - Resource Manager Namespace Specification (A)
- Resource manager namespace specification

**RMRECSPEC** - Resource Manager Record Specification (A)
- Resource manager record specification

**RMREQUESTOR** - Resource Manager Requestor (A)
- Resource manager requestor identifier

**RMSEGSPEC** - Resource Manager Segment Specification (A)
- Resource manager segment specification

**RMSPACE** - Resource Manager Space (A)
- Resource manager space identifier

**RMSPWD** - Resource Manager Space Password (A)
- Password for resource manager space

**RMSUSERID** - Resource Manager Space User ID (A)
- User ID for resource manager space

**ROWCT** - Row Count (U2)
- Number of rows

**RPMACK** - Report Parameter Acknowledge (B[1])
- Report parameter acknowledgment

**RPSEL** - Report Selection (U1)
- Report selection criteria

**RPTID** - Report ID (U1, U2, U4, or A)
- Unique identifier for report

**RPTOC** - Report Occurrence (U2)
- Report occurrence count

**RQCMD** - Request Command (A)
- Request command string

**RRACK** - Recipe Request Acknowledge (B[1])
- Recipe request acknowledgment

**RRACK_S20** - Recipe Request Acknowledge S20 (B[1])
- S20 specific recipe request acknowledgment

**RSACK** - Recipe Send Acknowledge (B[1])
- Recipe send acknowledgment

**RSDA** - Recipe Send Data A (A)
- Recipe send data in ASCII

**RSDC** - Recipe Send Data C (various)
- Recipe send data compressed

**RSINF** - Recipe Send Information (A)
- Recipe send information

**RSPACK** - Reset Spool Acknowledge (B[1])
- Reset spool acknowledgment

**RTSRSPSTAT** - Real Time Status Response Status (B[1])
- Real time status response

**RTYPE** - Report Type (U1)
- Type of report

**RecID** - Record ID (A)
- Record identifier

**SDACK** - Send Data Acknowledge (B[1])
- Send data acknowledgment

**SDBIN** - Send Data Binary (B)
- Binary data to send

**SENDRSPSTAT** - Send Response Status (B[1])
- Status of send response

**SEQNUM** - Sequence Number (U4)
- Sequence number

**SFCD** - Stream Function Code (U2)
- SECS stream and function code

**SHEAD** - Stream Header (B[4])
- Stream header information

**SLOTID** - Slot ID (U1, U2)
- Slot identifier

**SMPLN** - Sample Number (U1, U2, U4)
- Sample identification number

**SOFTREV** - Software Revision (A[20])
- Software revision string

**SPAACK** - Substrate Position Acknowledge (B[1])
- Substrate position acknowledgment

**SPD** - Substrate Position Data (various)
- Substrate position information

**SPID** - Substrate Position ID (A)
- Substrate position identifier

**SPNAME** - Substrate Position Name (A)
- Name of substrate position

**SPR** - Substrate Position Reference (A)
- Reference for substrate position

**SPVAL** - Substrate Position Value (various)
- Value of substrate position

**SSAACK** - Substrate Status Acknowledge (B[1])
- Substrate status acknowledgment

**SSACK** - Substrate Send Acknowledge (B[1])
- Substrate send acknowledgment

**SSCMD** - Substrate Send Command (A)
- Substrate send command

**STATUS** - Status (U1)
- General status indicator

**STATUSTXT** - Status Text (A)
- Status description text

**STIME** - Start Time (A)
- Start time stamp

**STRACK** - Substrate Track (A)
- Substrate tracking identifier

**STRID** - Stream ID (B[1])
- SECS stream identifier

**STRP** - Map Strip Data (various)
- Wafer map strip data

**SV** - Status Variable (various)
- Status variable value

**SV0** - Status Variable 0 (various)
- First status variable

**SVCACK** - Service Acknowledge (B[1])
- Service acknowledgment

**SVCNAME** - Service Name (A)
- Name of service

**SVID** - Status Variable ID (U1, U2, U4, or A)
- Status variable identifier

**SVNAME** - Status Variable Name (A)
- Name of status variable

**TARGETID** - Target ID (A)
- Target identifier

**TARGETPDE** - Target Process Data Element (A)
- Target process data element

**TARGETSPEC** - Target Specification (A)
- Target specification

**TBLACK** - Table Acknowledge (B[1])
- Table operation acknowledgment

**TBLCMD** - Table Command (A)
- Table command

**TBLELT** - Table Element (various)
- Table element data

**TBLID** - Table ID (A)
- Table identifier

**TBLTYP** - Table Type (U1)
- Type of table

**TCID** - Transaction Control ID (A)
- Transaction control identifier

**TEXT** - Text (A)
- Text data

**TIAACK** - Trace Initialize Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, Insufficient space
- 2: Denied, Invalid format
- 3: Denied, At least one SVID does not exist
- 4: Denied, Busy

**TIACK** - Time Acknowledge (B[1])
- 0: Acknowledged
- 1: Error

**TID** - Terminal ID (B[1])
- Terminal identifier

**TIME** - Time (A[16])
- Time stamp in format "YYMMDDhhmmss[cc]"

**TIMESTAMP** - Time Stamp (A)
- General timestamp

**TOTSMP** - Total Samples (U1, U2, U4)
- Total number of samples

**TRACK** - Track (A)
- Track identifier

**TRANSFERSIZE** - Transfer Size (U4)
- Size of data transfer

**TRATOMCID** - Transaction Atomic ID (A)
- Atomic transaction identifier

**TRAUTOD** - Transaction Auto Delete (BOOLEAN)
- Auto delete transaction flag

**TRAUTOSTART** - Transaction Auto Start (BOOLEAN)
- Auto start transaction flag

**TRCMDNAME** - Transaction Command Name (A)
- Name of transaction command

**TRDIR** - Transfer Direction (U1)
- Direction of transfer

**TRID** - Trace Request ID (U1, U2, U4, or A)
- Trace request identifier

**TRJOBID** - Transaction Job ID (A)
- Transaction job identifier

**TRJOBMS** - Transaction Job Milestone (A)
- Transaction job milestone

**TRJOBNAME** - Transaction Job Name (A)
- Name of transaction job

**TRLINK** - Transaction Link (A)
- Transaction link identifier

**TRLOCATION** - Transaction Location (A)
- Transaction location

**TROBJNAME** - Transaction Object Name (A)
- Name of transaction object

**TROBJTYPE** - Transaction Object Type (A)
- Type of transaction object

**TRPORT** - Transfer Port (U1)
- Transfer port number

**TRPTNR** - Transfer Partner (A)
- Transfer partner identifier

**TRPTPORT** - Transfer Point Port (U1)
- Transfer point port

**TRRCP** - Transaction Recipe (A)
- Transaction recipe

**TRROLE** - Transaction Role (A)
- Role in transaction

**TRTYPE** - Transfer Type (U1)
- Type of transfer

**TSIP** - Time Stamp Input (A)
- Input timestamp

**TSOP** - Time Stamp Output (A)
- Output timestamp

**TTC** - Total Transfer Count (U4)
- Total count of transfers

**TYPEID** - Type ID (A)
- Type identifier

**UID** - User ID (A)
- User identifier

**UNFLEN** - Unformatted Length (U4)
- Length of unformatted data

**UNITS** - Units (A)
- Measurement units

**UPPERDB** - Upper Deadband (various)
- Upper deadband value

**V** - Variable Value (various)
- Generic variable value

**VERID** - Version ID (A)
- Version identifier

**VERIFYDEPTH** - Verify Depth (U1)
- Depth of verification

**VERIFYRSPSTAT** - Verify Response Status (B[1])
- Verification response status

**VERIFYSUCCESS** - Verify Success (BOOLEAN)
- Verification success flag

**VERIFYTYPE** - Verify Type (U1)
- Type of verification

**VID** - Variable ID (U1, U2, U4, or A)
- Variable identifier

**VLAACK** - Variable Limit Attribute Acknowledge (B[1])
- Variable limit attribute acknowledgment

**WRACK** - Write Acknowledge (B[1])
- Write operation acknowledgment

**XDIES** - X Dies (U2)
- Number of dies in X direction

**XYPOS** - XY Position (F4, F8)
- X,Y coordinate position

**YDIES** - Y Dies (U2)
- Number of dies in Y direction
                Hex: D1 04 FF FF FF FF

Signed Int:    I1[1] = -128
                Hex: 81 01 80

               I2[1] = -32768
                Hex: 71 01 80 00

Float:         F4[1] = 3.14159
                Hex: B1 04 40 49 0F D0

List:          {L[2] item1 item2}
                Hex: 01 02 ... ...

Empty List:    {L:0}
                Hex: 01 00
```

## Implementation Guidelines

### 1. Message Validation
- Verify message length consistency
- Validate stream/function combinations
- Check wait bit appropriateness
- Ensure proper system bytes uniqueness

### 2. Response Handling
- Always respond to messages with wait bit set
- Use same system bytes in response
- Implement proper timeout handling
- Handle transaction aborts gracefully

### 3. State Management
- Track connection state (Not Connected, Selected, Online)
- Implement proper state transitions
- Handle communication establishment sequence
- Manage heartbeat and linktest mechanisms

### 4. Error Handling
- Implement S9 error messages for invalid requests
- Use proper reject codes
- Log communication errors appropriately
- Provide meaningful error descriptions

### 5. Data Encoding
- Use appropriate SECS-II data types
- Handle endianness correctly
- Validate data item structure
- Support multi-byte length fields when needed

## References

- SEMI E5 Specification
- SEMI E37 HSMS Generic Services
- SEMI E30 GEM (Generic Equipment Model)

--- 