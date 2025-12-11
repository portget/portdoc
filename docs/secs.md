# SECS Message Format Specification

## Table of Contents
1. [Overview](#overview) 
2. [Configure](#configure)
3. [Sample Scenario](#sample-scenario-table)
3. [Quick Link](#quick-link) 
4. [Script Definitions](#script-stream-definitions)

## Overview

Port Application provides simulation capabilities using scripts(*.sna). Users can utilize this to proceed with development based on testing before service deployment. 

## Configure 

(../app/gem/.gem)

```
Mode = active
Listen = 127.0.0.1:6000
DeviceID = 0
T1 = 1
T2 = 10 
T3 = 45
T4 = 30
T5 = 10
T6 = 5
T7 = 10
T8 = 5
LogFileExt = .log
LogDir	   = ./hsms
LogRetentionDay = 30
LogRotationHour = 1
MaxRetriesCount = 10
RetryDelaySec = 3
ConnectTimeout = 10
```

**Download Sample:**
[Download Sample Project](file/secs.zip)

## Sample Scenario Table

The following table outlines the SECS/GEM communication scenario for material handling, event reporting, and process execution in a semiconductor manufacturing environment.

| Message | Direction | Description | Details |
|---------|-----------|-------------|---------|
| S1F13 | H → E | Establish Communication Request | Initiates communication between host and equipment. |
| S1F14 | E → H  | Acknowledge | Confirms successful communication establishment. |
| S6F11 | E → H  | Event Report Send | Reports OnlineRemote event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges receipt of S6F11 event report. |
| S2F37 | H → E | Disable Event | Requests disabling of specific event reporting. |
| S2F38 | E → H  | Acknowledge | Confirms event disabling. |
| S2F33 | H → E | Delete Reports All | Requests deletion of all defined reports. |
| S2F34 | E → H  | Acknowledge | Confirms deletion of reports. |
| S2F33 | H → E | Define Report | Defines new report structure for event reporting. |
| S2F34 | E → H  | Acknowledge | Confirms report definition. |
| S2F35 | H → E | Link Event Report | Links events to defined reports. |
| S2F36 | E → H  | Acknowledge | Confirms event-report linkage. |
| S2F37 | H → E | Enable Event | Requests enabling of specific event reporting. |
| S2F38 | E → H  | Acknowledge | Confirms event enabling. |
| S6F11 | E → H  | Event Report Send | Reports LP_In_Service event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_In_Service event. |
| S3F27 | E → H  | Port Access Mode - Auto | Sets load port to automatic access mode. |
| S3F28 | H → E | Acknowledge | Confirms port access mode change. |
| S6F11 | E → H  | Event Report Send | Reports LP_AccessModeChanged event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_AccessModeChanged event. |
| S6F11 | E → H  | Event Report Send | Reports LP_ReadyToLoad event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_ReadyToLoad event. |
| S6F11 | E → H  | Event Report Send | Reports LP_TRReady event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_TRReady event. |
| - | - | Load Port Transfer State | Load port is in Ready To Load state. |
| - | - | Operator Action | Operator delivers carrier and loads it onto the load port. |
| S6F11 | E → H  | Event Report Send | Reports Load Complete event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges Load Complete event. |
| S6F11 | E → H  | Event Report Send | Reports LP_TransferBlocked event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_TransferBlocked event. |
| S6F11 | E → H  | Event Report Send | Reports LP_CarrierClamped event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_CarrierClamped event. |
| S6F11 | E → H  | Event Report Send | Reports LP_CarrierID Waiting for Host event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_CarrierID Waiting event. |
| S3F17 | H → E | PROCEEDWITHCARRIER Event | Host verifies the carrier ID. |
| S3F18 | E → H  | Acknowledge | Confirms carrier ID verification. |
| S6F11 | E → H  | Event Report Send | Reports LP_CarrierID_VERIFICATION_OK event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_CarrierID_VERIFICATION_OK event. |
| S6F11 | E → H  | Event Report Send | Reports LP_CarrierDocked event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_CarrierDocked event. |
| S6F11 | E → H  | Event Report Send | Reports LP_DoorOpened event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_DoorOpened event. |
| S6F11 | E → H  | Event Report Send | Reports LP_SlotMap Waiting for Host event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_SlotMap Waiting event. |
| S3F17 | H → E | PROCEEDWITHCARRIER Event | Host verifies the slot map. |
| S3F18 | E → H  | Acknowledge | Confirms slot map verification. |
| S6F11 | E → H  | Event Report Send | Reports LP_SlotMap_VERIFICATION_OK event (CEID = n). |
| S16F15 | H → E | ProcessJob Create | Creates process job with recipe, lot ID, and wafer details. |
| S16F16 | E → H  | Acknowledge | Confirms process job creation. |
| S6F11 | E → H  | Event Report Send | Reports PrJobStateChanged event (CEID = n, PrJobStatus = Pooled). |
| S6F12 | H → E | Acknowledge | Acknowledges PrJobStateChanged event. |
| S14F9 | H → E | ControlJob Start | Initiates control job start. |
| S14F10 | E → H  | Acknowledge | Confirms control job start. |
| S6F11 | E → H  | Event Report Send | Reports ControlJobStateChanged event (CEID = n, CrJobStatus = Queued). |
| S6F12 | H → E | Acknowledge | Acknowledges ControlJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports ControlJobStateChanged event (CEID = n, CrJobStatus = Selected). |
| S6F12 | H → E | Acknowledge | Acknowledges ControlJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports ControlJobStateChanged event (CEID = n, CrJobStatus = Waiting). |
| S6F12 | H → E | Acknowledge | Acknowledges ControlJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports ControlJobStateChanged event (CEID = n, CrJobStatus = Executing). |
| S6F12 | H → E | Acknowledge | Acknowledges ControlJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports PrJobStateChanged event (CEID = n, PrJobStatus = Setting Up). |
| S6F12 | H → E | Acknowledge | Acknowledges PrJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports PrJobStateChanged event (CEID = n, PrJobStatus = Waiting). |
| S6F12 | H → E | Acknowledge | Acknowledges PrJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports PrJobStateChanged event (CEID = n, PrJobStatus = Processing). |
| S6F12 | H → E | Acknowledge | Acknowledges PrJobStateChanged event. |
| S6F11 | E → H  | Event Report Send | Reports WaferProcessStart event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WaferProcessStart event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER CASSETTE TO ROBOT UPPER ARM event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER CASSETTE TO ROBOT UPPER ARM event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER ROBOT UPPER ARM TO ALIGN event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER ROBOT UPPER ARM TO ALIGN event. |
| S6F11 | E → H  | Event Report Send | Reports Pre Align Start event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges Pre Align Start event. |
| S6F11 | E → H  | Event Report Send | Reports Pre Align End event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges Pre Align End event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER ALIGN TO ROBOT UPPER ARM event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER ALIGN TO ROBOT UPPER ARM event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER ROBOT UPPER ARM TO stage(A) event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER ROBOT UPPER ARM TO stage(A) event. |
| S6F11 | E → H  | Event Report Send | Reports Statge(A) Processing Start event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges Statge(A) Processing Start event. |
| S6F11 | E → H  | Event Report Send | Reports Statge(A) Processing End event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges Statge(A) Processing End event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER stage(A) TO ROBOT UPPER ARM event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER stage(A) TO ROBOT UPPER ARM event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER ROBOT UPPER ARM TO MOIRE event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER ROBOT UPPER ARM TO MOIRE event. |
| S6F11 | E → H  | Event Report Send | Reports stage(B) Processing Start event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges stage(B) Processing Start event. |
| S6F11 | E → H  | Event Report Send | Reports stage(B) Processing End event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges stage(B) Processing End event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER MOIRE TO ROBOT UPPER ARM event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER MOIRE TO ROBOT UPPER ARM event. |
| S6F11 | E → H  | Event Report Send | Reports WAFER ROBOT UPPER ARM TO CASSETTE event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WAFER ROBOT UPPER ARM TO CASSETTE event. |
| S6F11 | E → H  | Event Report Send | Reports WaferProcessEnd event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges WaferProcessEnd event. |
| - | - | Data Upload | Wafer Dcolldata is uploaded to the host. |
| S6F11 | E → H | Event Report Send | Reports PrJobStateChanged event (CEID = n, PrJobStatus = Completed). |
| S6F12 | H → E | Acknowledge | Acknowledges PrJobStateChanged event. |
| S6F11 | E → H | Event Report Send | Reports ControlJobStateChanged event (CEID = n, CrJobStatus = Completed). |
| S6F12 | H → E | Acknowledge | Acknowledges ControlJobStateChanged event. |
| S6F11 | E → H | Event Report Send | Reports LP_DoorClosed event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_DoorClosed event. |
| S6F11 | E → H | Event Report Send | Reports LP_CarrierUndocked event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_CarrierUndocked event. |
| S6F11 | E → H | Event Report Send | Reports LP_CarrierUnclamped event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_CarrierUnclamped event. |
| S6F11 | E → H | Event Report Send | Reports LP_ReadyToUnload event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_ReadyToUnload event. |
| S6F11 | E → H | Event Report Send | Reports LP_TRReady event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_TRReady event. |
| S6F11 | E → H | Event Report Send | Reports LP_TransferBlocked event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_TransferBlocked event. |
| S6F11 | E → H | Event Report Send | Reports LP_UnloadComplete event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_UnloadComplete event. |
| S6F11 | E → H | Event Report Send | Reports ControlJobStateChanged event (CEID = n, CrJobStatus = Deleted). |
| S6F12 | H → E | Acknowledge | Acknowledges ControlJobStateChanged event. |
| S6F11 | E → H | Event Report Send | Reports LP_ReadyToLoad event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_ReadyToLoad event. |
| S6F11 | E → H | Event Report Send | Reports LP_TRReady event (CEID = n). |
| S6F12 | H → E | Acknowledge | Acknowledges LP_TRReady event. |




## **Quick link** {#quick-link}
| Stream | Function |
|---|---|
| S1 | [F1](#s1f1---are-you-there-request) [F2](#s1f2---are-you-there-response) [F3](#s1f3r---selected-equipment-status-request) [F4](#s1f4---selected-equipment-status-data) [F5](#s1f5r---formatted-status-request) [F6](#s1f6---formatted-status-data) [F7](#s1f7---fixed-form-request) [F8](#s1f8---fixed-form-data) [F9](#s1f9r---material-transfer-status-request) [F10](#s1f10---material-transfer-status-data) [F11](#s1f11r---status-variable-namelist-request) [F12](#s1f12---status-variable-namelist-reply) [F13](#s1f13r---establish-communications-request) [F14](#s1f14---establish-communications-request-acknowledge) [F15](#s1f15r---request-offline) [F16](#s1f16---offline-acknowledge) [F17](#s1f17r---request-online) [F18](#s1f18---online-acknowledge) [F19](#s1f19r---get-attribute) [F20](#s1f20---attribute-data) [F21](#s1f21r---data-variable-namelist-request) [F22](#s1f22---data-variable-namelist-reply) [F23](#s1f23r---collection-event-namelist-request) [F24](#s1f24---collection-event-namelist-reply) |
| S2 | [F1](#s2f1---equipment-status-request) [F2](#s2f2---equipment-status-response) [F3](#s2f3---status-variable-value-request) [F4](#s2f4---status-variable-value-response) [F5](#s2f5---send-equipment-status) [F6](#s2f6---send-equipment-status-acknowledge) [F7](#s2f7---load-port-status-request) [F8](#s2f8---load-port-status-response) [F9](#s2f9---equipment-status-multi-block-inquire) [F10](#s2f10---equipment-status-multi-block-grant) [F11](#s2f11---equipment-status-multi-block) [F12](#s2f12---equipment-status-multi-block-acknowledge) [F13](#s2f13---equipment-constant-request) [F14](#s2f14---equipment-constant-response) [F15](#s2f15---new-equipment-constant-send) [F16](#s2f16---new-equipment-constant-acknowledge) [F17](#s2f17---date-and-time-request) [F18](#s2f18---date-and-time-response) [F19](#s2f19---recipe-body-request) [F20](#s2f20---recipe-body-response) [F21](#s2f21---recipe-body-send) [F22](#s2f22---recipe-body-acknowledge) [F23](#s2f23---trace-initialize-send) [F24](#s2f24---trace-initialize-acknowledge) [F25](#s2f25---loopback-diagnostic-request) [F26](#s2f26---loopback-diagnostic-response) [F27](#s2f27---initiate-processing-request) [F28](#s2f28---initiate-processing-acknowledge) [F29](#s2f29---equipment-constant-namelist-request) [F30](#s2f30---equipment-constant-namelist-response) [F31](#s2f31---date-and-time-set-request) [F32](#s2f32---date-and-time-set-response) [F33](#s2f33---define-report) [F34](#s2f34---define-report-acknowledge) [F35](#s2f35---link-event-report) [F36](#s2f36---link-event-report-acknowledge) [F37](#s2f37---enabledisable-event-report) [F38](#s2f38---enabledisable-event-report-acknowledge) [F39](#s2f39---status-variable-namelist-request) [F40](#s2f40---status-variable-namelist-response) [F41](#s2f41---host-command-send) [F42](#s2f42---host-command-acknowledge) [F43](#s2f43---reset-spooling-streams-and-functions) [F44](#s2f44---reset-spooling-acknowledge) [F45](#s2f45---define-variable-limit-attributes) [F46](#s2f46---define-variable-limit-attributes-acknowledge) [F47](#s2f47---variable-limit-attribute-request) [F48](#s2f48---variable-limit-attribute-response) [F49](#s2f49---enhanced-remote-command) [F50](#s2f50---enhanced-remote-command-acknowledge) [F51](#s2f51---request-report-identifiers) [F52](#s2f52---return-report-identifiers) [F53](#s2f53---request-report-definitions) [F54](#s2f54---return-report-definitions) [F55](#s2f55---request-event-report-links) [F56](#s2f56---return-event-report-links) [F57](#s2f57---request-enabled-events) [F58](#s2f58---return-enabled-events) [F59](#s2f59---request-spool-streams-and-functions) [F60](#s2f60---return-spool-streams-and-functions) [F61](#s2f61---request-trace-identifiers) [F62](#s2f62---return-trace-identifiers) [F63](#s2f63---request-trace-definitions) [F64](#s2f64---return-trace-definitions) |
| S3 | [F1](#s3f1---material-status-request) [F2](#s3f2---material-status-data) [F3](#s3f3---time-to-completion-data) [F4](#s3f4---time-to-completion-data) [F5](#s3f5---material-found-send) [F6](#s3f6---material-found-acknowledge) [F7](#s3f7---material-lost-send) [F8](#s3f8---material-lost-ack) [F9](#s3f9---matl-id-equate-send) [F10](#s3f10---port-status-acknowledge) [F11](#s3f11---matl-id-request) [F12](#s3f12---matl-id-request-ack) [F13](#s3f13---matl-id-send) [F14](#s3f14---matl-id-ack) [F15](#s3f15---matls-multi-block-inquire) [F16](#s3f16---matls-multi-block-grant) [F17](#s3f17---carrier-action-request-extended) [F18](#s3f18---carrier-action-response-extended) [F19](#s3f19---port-action-request) [F20](#s3f20---cancel-all-carrier-out-ack) [F21](#s3f21---port-group-defn) [F22](#s3f22---port-group-defn-ack) [F23](#s3f23---port-group-action-req) [F24](#s3f24---port-group-action-ack) [F25](#s3f25---port-action-req) [F26](#s3f26---port-action-ack) [F27](#s3f27---change-access) [F28](#s3f28---change-access-ack) [F29](#s3f29---carrier-tag-read-req) [F30](#s3f30---carrier-tag-read-data) [F31](#s3f31---carrier-tag-write-data) [F32](#s3f32---carrier-tag-write-ack) [F33](#s3f33---cancel-all-pod-out-req) [F34](#s3f34---cancel-all-pod-out-ack) [F35](#s3f35---reticle-transfer-job-req) [F36](#s3f36---reticle-transfer-job-ack) |
| S4 | [F1](#s4f1---ready-to-send-materials) [F2](#s4f2---ready-to-send-acknowledge) [F3](#s4f3---send-material) [F5](#s4f5---handshake-complete) [F7](#s4f7---not-ready-to-send) [F9](#s4f9---stuck-in-sender) [F11](#s4f11---stuck-in-receiver) [F13](#s4f13---send-incomplete-timeout) [F15](#s4f15---material-received) [F17](#s4f17---request-to-receive) [F18](#s4f18---request-to-receive-acknowledge) [F19](#s4f19---transfer-job-create) [F20](#s4f20---transfer-job-acknowledge) [F21](#s4f21---transfer-job-command) |
| S5 | [F1](#s5f1---alarm-report-send) [F2](#s5f2---alarm-report-acknowledge) [F3](#s5f3---enabledisable-alarm-send) [F4](#s5f4---enabledisable-alarm-acknowledge) [F5](#s5f5---list-alarms-request) [F6](#s5f6---list-alarms-response) [F7](#s5f7---list-enabled-alarm-request) [F8](#s5f8---list-enabled-alarm-response) |
| S6 | [F1](#s6f1---trace-data-send) [F2](#s6f2---trace-data-acknowledge) [F3](#s6f3---discrete-variable-data-send) [F4](#s6f4---discrete-variable-data-acknowledge) [F5](#s6f5---multi-block-data-send-inquire) [F6](#s6f6---multi-block-grant) [F7](#s6f7---data-transfer-request) [F8](#s6f8---data-transfer-data) [F9](#s6f9---formatted-variable-send) [F10](#s6f10---formatted-variable-acknowledge) [F11](#s6f11---event-report-send) [F12](#s6f12---event-report-acknowledge) [F13](#s6f13---annotated-event-report-send) [F14](#s6f14---annotated-event-report-acknowledge) [F15](#s6f15---event-report-request) [F16](#s6f16---event-report-data) [F17](#s6f17---annotated-event-report-request) [F18](#s6f18---annotated-event-report-data) [F19](#s6f19---individual-report-request) [F20](#s6f20---individual-report-data) [F21](#s6f21---annotated-individual-report-request) [F22](#s6f22---annotated-individual-report-data) [F23](#s6f23---request-or-purge-spooled-data) [F24](#s6f24---request-or-purge-spooled-data-acknowledge) [F25](#s6f25---notification-report-send) [F26](#s6f26---notification-report-acknowledge) [F27](#s6f27---trace-report-send) [F28](#s6f28---trace-report-acknowledge) [F29](#s6f29---trace-report-request) [F30](#s6f30---trace-report-data) |
| S7 | [F1](#s7f1---process-program-load-inquire) [F2](#s7f2---process-program-load-grant) [F3](#s7f3---process-program-send) [F4](#s7f4---process-program-send-acknowledge) [F5](#s7f5---process-program-request) [F6](#s7f6---process-program-data) [F7](#s7f7---process-program-id-request) [F8](#s7f8---process-program-id-data) [F9](#s7f9---material-process-matrix-request) [F10](#s7f10---material-process-matrix-data) [F11](#s7f11---material-process-matrix-update-send) [F12](#s7f12---material-process-matrix-update-acknowledge) [F13](#s7f13---material-process-matrix-delete-entry-send) [F14](#s7f14---delete-material-process-matrix-entry-acknowledge) [F15](#s7f15---matrix-mode-select-send) [F16](#s7f16---matrix-mode-select-acknowledge) [F17](#s7f17---delete-process-program-send) [F18](#s7f18---delete-process-program-acknowledge) [F19](#s7f19---current-process-program-directory-request) [F20](#s7f20---current-process-program-data) [F21](#s7f21---process-capabilities-request) [F22](#s7f22---process-capabilities-data) [F23](#s7f23---formatted-process-program-send) [F24](#s7f24---formatted-process-program-acknowledge) [F25](#s7f25---formatted-process-program-request) [F26](#s7f26---formatted-process-program-data) [F27](#s7f27---process-program-verification-send) [F28](#s7f28---process-program-verification-acknowledge) [F29](#s7f29---process-program-verification-inquire) [F30](#s7f30---process-program-verification-grant) [F31](#s7f31---verification-request-send) [F32](#s7f32---verification-request-acknowledge) [F33](#s7f33---process-program-available-request) [F34](#s7f34---process-program-availability-data) [F35](#s7f35---process-program-for-mid-request) [F36](#s7f36---process-program-for-mid-data) [F37](#s7f37---large-process-program-send) [F38](#s7f38---large-process-program-send-acknowledge) [F39](#s7f39---large-formatted-process-program-send) [F40](#s7f40---large-formatted-process-program-acknowledge) [F41](#s7f41---large-process-program-request) [F42](#s7f42---large-process-program-request-acknowledge) [F43](#s7f43---large-formatted-process-program-request) [F44](#s7f44---large-formatted-process-program-request-acknowledge) |
| S8 | [F1](#s8f1---boot-program-request) [F2](#s8f2---boot-program-data) [F3](#s8f3---executive-program-request) [F4](#s8f4---executive-program-data) |
| S9 | [F1](#s9f1---unrecognized-device-id) [F3](#s9f3---unrecognized-stream-type) [F5](#s9f5---unrecognized-function-type) [F7](#s9f7---illegal-data) [F9](#s9f9---transaction-timer-timeout) [F11](#s9f11---data-too-long) [F13](#s9f13---conversation-timeout) |
| S10 | [F1](#s10f1---terminal-request) [F2](#s10f2---terminal-response) [F3](#s10f3---terminal-display-single) [F5](#s10f5---terminal-display-multi-block) [F7](#s10f7---multi-block-not-allowed) [F9](#s10f9---broadcast-display-request) [F10](#s10f10---broadcast-display-acknowledge) |
| S12 | [F1](#s12f1---map-setup-data-send) [F2](#s12f2---map-setup-data-acknowledge) [F3](#s12f3---map-setup-data-request) [F4](#s12f4---map-setup-data-response) [F5](#s12f5---map-transmit-inquire) [F6](#s12f6---map-transmit-grant) [F7](#s12f7---map-data-send-type-1) [F8](#s12f8---map-data-ack-type-1) [F9](#s12f9---map-data-send-type-2) [F10](#s12f10---map-data-ack-type-2) [F11](#s12f11---map-data-send-type-3) [F12](#s12f12---map-data-ack-type-3) [F13](#s12f13---map-data-request-type-1) [F14](#s12f14---map-data-type-1) [F15](#s12f15---map-data-request-type-2) [F16](#s12f16---map-data-type-2) [F17](#s12f17---map-data-request-type-3) [F18](#s12f18---map-data-type-3) [F19](#s12f19---map-error-report-send) |
| S13 | [F1](#s13f1---send-data-set-send) [F2](#s13f2---send-data-set-ack) [F3](#s13f3---open-data-set-request) [F4](#s13f4---open-data-set-data) [F5](#s13f5---read-data-set-request) [F6](#s13f6---read-data-set-data) [F7](#s13f7---close-data-set-send) [F8](#s13f8---close-data-set-ack) [F9](#s13f9---reset-data-set-send) [F10](#s13f10---reset-data-set-ack) [F11](#s13f11---data-set-obj-multi-block-inquire) [F12](#s13f12---data-set-obj-multi-block-grant) [F13](#s13f13---table-data-send) [F14](#s13f14---table-data-ack) [F15](#s13f15---table-data-request) [F16](#s13f16---table-data) |
| S14 | [F1](#s14f1---get-attributes-request) [F2](#s14f2---attribute-data) [F3](#s14f3---set-attributes) [F4](#s14f4---set-attributes-reply) [F5](#s14f5---get-type-data) [F6](#s14f6---type-data) [F7](#s14f7---get-attribute-names) [F8](#s14f8---attribute-names) [F9](#s14f9---create-obj-request) [F10](#s14f10---create-obj-ack) [F11](#s14f11---delete-obj-request) [F12](#s14f12---delete-obj-ack) [F13](#s14f13---object-attach-request) [F14](#s14f14---object-attach-ack) [F15](#s14f15---attached-obj-action-req) [F16](#s14f16---attached-obj-action-ack) [F17](#s14f17---supervised-obj-action-req) [F18](#s14f18---supervised-obj-action-ack) [F19](#s14f19---generic-service-req) [F20](#s14f20---generic-service-ack) [F21](#s14f21---generic-service-completion) [F22](#s14f22---generic-service-comp-ack) [F23](#s14f23---multi-block-generic-service-inquire) [F24](#s14f24---multi-block-generic-service-grant) [F25](#s14f25---service-name-request) [F26](#s14f26---service-name-data) [F27](#s14f27---service-parameter-name-req) [F28](#s14f28---service-parameter-name-data) |
| S15 | [F1](#s15f1---recipe-management-multi-block-inquire) [F2](#s15f2---recipe-management-multi-block-grant) [F3](#s15f3---recipe-namespace-action-req) [F4](#s15f4---recipe-namespace-action) [F5](#s15f5---recipe-namespace-rename-req) [F6](#s15f6---recipe-namespace-rename-ack) [F7](#s15f7---recipe-space-req) [F8](#s15f8---recipe-space-data) [F9](#s15f9---recipe-status-request) [F10](#s15f10---recipe-status-data) [F11](#s15f11---recipe-version-request) [F12](#s15f12---recipe-version-data) [F13](#s15f13---recipe-create-req) [F14](#s15f14---recipe-create-ack) [F15](#s15f15---recipe-store-req) [F16](#s15f16---recipe-store-ack) [F17](#s15f17---recipe-retrieve-req) [F18](#s15f18---recipe-retrieve-data) [F19](#s15f19---recipe-rename-req) [F20](#s15f20---recipe-rename-ack) [F21](#s15f21---recipe-action-req) [F22](#s15f22---recipe-action-ack) [F23](#s15f23---recipe-descriptor-req) [F24](#s15f24---recipe-descriptor-data) [F25](#s15f25---recipe-parameter-update-req) [F26](#s15f26---recipe-parameter-update-ack) [F27](#s15f27---recipe-download-req) [F28](#s15f28---recipe-download-ack) [F29](#s15f29---recipe-verify-req) [F30](#s15f30---recipe-verify-ack) [F31](#s15f31---recipe-unload-req) [F32](#s15f32---recipe-unload-data) [F33](#s15f33---recipe-select-req) [F34](#s15f34---recipe-select-ack) [F35](#s15f35---recipe-delete-req) [F36](#s15f36---recipe-delete-ack) [F37](#s15f37---drns-segment-approve-action-req) [F38](#s15f38---drns-segment-approve-action-ack) [F39](#s15f39---drns-recorder-seg-req) [F40](#s15f40---drns-recorder-seg-ack) [F41](#s15f41---drns-recorder-mod-req) [F42](#s15f42---drns-recorder-mod-ack) [F43](#s15f43---drns-get-change-req) [F44](#s15f44---drns-get-change-ack) [F45](#s15f45---drns-mgr-seg-aprvl-req) [F46](#s15f46---drns-mgr-seg-aprvl-ack) [F47](#s15f47---drns-mgr-rebuild-req) [F48](#s15f48---drns-mgr-rebuild-ack) [F49](#s15f49---large-recipe-download-req) [F50](#s15f50---large-recipe-download-ack) [F51](#s15f51---large-recipe-upload-req) [F52](#s15f52---large-recipe-upload-ack) [F53](#s15f53---recipe-verification-send) [F54](#s15f54---recipe-verification-ack) |
| S16 | [F1](#s16f1---process-job-data-mbi) [F2](#s16f2---pjd-mbi-grant) [F3](#s16f3---process-job-create-req) [F4](#s16f4---process-job-create-ack) [F5](#s16f5---process-job-cmd-req) [F6](#s16f6---process-job-cmd-ack) [F7](#s16f7---process-job-alert-notify) [F8](#s16f8---process-job-alert-ack) [F9](#s16f9---process-job-event-notify) [F10](#s16f10---process-job-event-ack) [F11](#s16f11---prjobcreateenh) [F12](#s16f12---prjobcreateenh-ack) [F15](#s16f15---prjobmulticreate) [F16](#s16f16---prjobmulticreate-ack) [F17](#s16f17---prjobdequeue) [F18](#s16f18---prjobdequeue-ack) [F19](#s16f19---prjob-list-req) [F20](#s16f20---prjob-list-data) [F21](#s16f21---prjob-create-limit-req) [F22](#s16f22---prjob-create-limit-data) [F23](#s16f23---prjob-recipe-variable-set) [F24](#s16f24---prjob-recipe-variable-ack) [F25](#s16f25---prjob-start-method-set) [F26](#s16f26---prjob-start-method-ack) [F27](#s16f27---control-job-command) [F28](#s16f28---control-job-command-ack) [F29](#s16f29---prsetmtrlorder) [F30](#s16f30---prsetmtrlorder-ack) |
| S17 | [F1](#s17f1---data-report-create-request) [F2](#s17f2---data-report-create-response) [F3](#s17f3---data-report-send) [F4](#s17f4---data-report-acknowledge) [F5](#s17f5---data-report-list-request) [F6](#s17f6---data-report-list-response) [F7](#s17f7---data-report-list-send) [F8](#s17f8---data-report-list-acknowledge) [F9](#s17f9---collection-event-link-request) [F10](#s17f10---collection-event-link-acknowledgment) [F11](#s17f11---collection-event-unlink-request) [F12](#s17f12---collection-event-unlink-acknowledgment) [F13](#s17f13---trace-reset-request) [F14](#s17f14---trace-reset-acknowledgment) |
| S18 | [F1](#s18f1---read-attribute-request) [F2](#s18f2---read-attribute-response) [F3](#s18f3---write-attribute-request) [F4](#s18f4---write-attribute-response) [F5](#s18f5---attribute-list-request) [F6](#s18f6---attribute-list-response) [F7](#s18f7---attribute-data-send) [F8](#s18f8---attribute-data-acknowledge) [F9](#s18f9---attribute-upload-request) [F10](#s18f10---read-id-data) [F11](#s18f11---write-id-request) [F12](#s18f12---write-id-acknowledgment) [F13](#s18f13---subsystem-command) [F14](#s18f14---subsystem-command-acknowledgment) [F15](#s18f15---read-2d-code-condition-request) [F16](#s18f16---read-2d-code-condition-data) |
| S19 | [F1](#s19f1---inventory-request) [F2](#s19f2---inventory-response) [F3](#s19f3---inventory-update) [F4](#s19f4---inventory-update-response) [F5](#s19f5---inventory-add-request) [F6](#s19f6---inventory-add-response) [F7](#s19f7---inventory-remove-request) [F8](#s19f8---inventory-remove-response) [F9](#s19f9---inventory-status-request) [F10](#s19f10---inventory-status-response) [F11](#s19f11---inventory-move-request) [F12](#s19f12---inventory-move-response) [F13](#s19f13---inventory-search-request) [F14](#s19f14---inventory-search-response) [F15](#s19f15---inventory-lock-request) [F16](#s19f16---inventory-lock-response) [F17](#s19f17---inventory-history-request) [F18](#s19f18---inventory-history-response) [F19](#s19f19---inventory-audit-request) [F20](#s19f20---inventory-audit-response) |ce-data-list-response) [F7](#s19f7---trace-data-list-send) [F8](#s19f8---trace-data-list-acknowledge) [F9](#s19f9---trace-data-upload-request) [F10](#s19f10---trace-data-upload-response) [F11](#s19f11---trace-data-upload-send) [F12](#s19f12---trace-data-upload-acknowledge) [F13](#s19f13---trace-data-download-request) [F14](#s19f14---trace-data-download-response) [F15](#s19f15---trace-data-download-send) [F16](#s19f16---trace-data-download-acknowledge) [F17](#s19f17---trace-data-validate-request) [F18](#s19f18---trace-data-validate-response) [F19](#s19f19---trace-data-validate-send) [F20](#s19f20---trace-data-validate-acknowledge) [F21](#s19f21---trace-data-compress-request) [F22](#s19f22---trace-data-compress-response) [F23](#s19f23---trace-data-compress-send) [F24](#s19f24---trace-data-compress-acknowledge) [F25](#s19f25---trace-data-encrypt-request) [F26](#s19f26---trace-data-encrypt-response) [F27](#s19f27---trace-data-encrypt-send) [F28](#s19f28---trace-data-encrypt-acknowledge) [F29](#s19f29---trace-data-decrypt-request) [F30](#s19f30---trace-data-decrypt-response) [F31](#s19f31---trace-data-decrypt-send) [F32](#s19f32---trace-data-decrypt-acknowledge) [F33](#s19f33---trace-data-backup-request) [F34](#s19f34---trace-data-backup-response) [F35](#s19f35---trace-data-restore-request) [F36](#s19f36---trace-data-restore-response) [F37](#s19f37---trace-data-archive-request) [F38](#s19f38---trace-data-archive-response) [F39](#s19f39---trace-data-unarchive-request) [F40](#s19f40---trace-data-unarchive-response) |
| S20 | [F1](#s20f1---setsro-attributes-request) [F2](#s20f2---setsro-attributes-acknowledge) [F3](#s20f3---getoperationidlist-request) [F4](#s20f4---getoperationidlist-acknowledge) [F5](#s20f5---openconnectionevent-send) [F6](#s20f6---openconnectionevent-acknowledge) [F7](#s20f7---closeconnectionevent-send) [F8](#s20f8---closeconnectionevent-acknowledge) [F9](#s20f9---clearoperation-request) [F10](#s20f10---clearoperation-acknowledge) [F11](#s20f11---getrecipexidlist-request) [F12](#s20f12---getrecipexidlist-acknowledge) [F13](#s20f13---deleterecipe-request) [F14](#s20f14---deleterecipe-acknowledge) [F15](#s20f15---writerecipe-request) [F16](#s20f16---writerecipe-acknowledge) [F17](#s20f17---readrecipe-request) [F18](#s20f18---readrecipe-acknowledge) [F19](#s20f19---queryrecipexidlist-event-send) [F20](#s20f20---queryrecipexidlist-event-acknowledge) [F21](#s20f21---queryrecipe-event-send) [F22](#s20f22---queryrecipe-event-acknowledge) [F23](#s20f23---postrecipe-event-send) [F24](#s20f24---postrecipe-event-acknowledge) [F25](#s20f25---setprc-attributes-request) [F26](#s20f26---setprc-attributes-acknowledge) [F27](#s20f27---prespecifyrecipe-request) [F28](#s20f28---prespecifyrecipe-acknowledge) [F29](#s20f29---querypjrecipexidlist-event-send) [F30](#s20f30---querypjrecipexidlist-event-acknowledge) [F31](#s20f31---pre-exe-check-event-send) [F32](#s20f32---pre-exe-check-event-acknowledge) [F33](#s20f33---prespecifyrecipe-event-send) [F34](#s20f34---prespecifyrecipe-event-acknowledge) |
| S21 | [F1](#s21f1---material-transfer-plan) [F2](#s21f2---material-transfer-plan-response) [F3](#s21f3---item-send) [F4](#s21f4---item-send-acknowledge) [F5](#s21f5---item-request) [F6](#s21f6---item-data) [F7](#s21f7---item-type-list-request) [F8](#s21f8---item-type-list-results) [F9](#s21f9---supported-item-type-list-request) [F10](#s21f10---supported-item-type-list-result) [F11](#s21f11---item-delete) [F12](#s21f12---item-delete-acknowledge) [F13](#s21f13---request-permission-to-send-item) [F14](#s21f14---grant-permission-to-send-item) [F15](#s21f15---item-request) [F16](#s21f16---item-request-grant) [F17](#s21f17---send-item-part) [F18](#s21f18---send-item-part-acknowledge) [F19](#s21f19---item-type-feature-support) [F20](#s21f20---item-type-feature-support-results) |



### Message Structure

#### Basic Format
```
{L[n]
  item_1
  item_2
  ...
  item_n
}

or

{L[n]
  GET(group_name.message_name1)
  GET(group_name.message_name2)
  ...
  GET(group_name.message_name[n])
}
```
 
- **L[n]**: List containing n items
- **item**: Individual data element of any supported type
 

## **Script Stream Definitions** {#script-stream-definitions}

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
<-S1F1 or S1F1->
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) |
 

---

#### **S1F2 - Are You There (Response)** {#s1f2---are-you-there-response}


```
S1F2-> or <-S1F2
{L[2]
  MDLN    // Equipment model name
  SOFTREV // Software revision
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| MDLN | ASCII | Equipment model name |
| SOFTREV | ASCII | Software revision |
 
---

#### **S1F3 - Selected Equipment Status Request** {#s1f3r---selected-equipment-status-request}
  
```
<-S1F3
{L[n]
  SVID    // Status Variable ID list
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SVID | List | List of Status Variable IDs to request |

 
---

#### **S1F4 - Selected Equipment Status Data** {#s1f4---selected-equipment-status-data}

```
S1F4->
{L[n]
  SV      // Status Variable values
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SV | List | Status variable values corresponding to requested SVIDs |

**Note**: Zero length values are returned for unknown SVIDs.

---

#### **S1F5R - Formatted Status Request** {#s1f5r---formatted-status-request}

```
<-S1F5
SFCD     // Status Format Code
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SFCD | U1/U2/U4/A | Status Format Code defining the requested format |

---

#### **S1F6 - Formatted Status Data** {#s1f6---formatted-status-data}

```
S1F6->
{L[n]
  SV      // Status Variable values
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SV | List | Formatted status variable values |

**Note**: Message structure varies by implementation and is superseded by dynamic reports.

---

#### **S1F7 - Fixed Form Request** {#s1f7---fixed-form-request}

```
<-S1F7
SFCD     // Status Format Code
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SFCD | U1/U2/U4/A | Status Format Code for fixed format |

---

#### **S1F8 - Fixed Form Data** {#s1f8---fixed-form-data}

```
S1F8->
{L[n]
  {L[2]
    SVNAME // Status Variable Name
    SV0    // Status Variable Value
  }
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SVNAME | ASCII | Status Variable Name |
| SV0 | Various | Status Variable Value |

---

#### **S1F9R - Material Transfer Status Request** {#s1f9r---material-transfer-status-request}

```
<-S1F9
Header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Header only message |


---

#### **S1F10 - Material Transfer Status Data** {#s1f10---material-transfer-status-data}

```
S1F10->
{L[2]
  TSIP    // Transfer Status Input Ports
  TSOP    // Transfer Status Output Ports
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| TSIP | List | Transfer Status Input Ports |
| TSOP | List | Transfer Status Output Ports |

**Note**: An L:0 reply can be sent if there are no material ports.

---

#### **S1F11R - Status Variable Namelist Request** {#s1f11r---status-variable-namelist-request}

```
<-S1F11
{L[n]
  SVID    // Status Variable ID list
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SVID | List | List of Status Variable IDs (L:0 requests all SVIDs) |

**Usage**: Host requests information about available status variables.

---

#### **S1F12 - Status Variable Namelist Reply** {#s1f12---status-variable-namelist-reply}

```
S1F12->
{L[n]
  {L[3]
    SVID    // Status Variable ID
    SVNAME  // Status Variable Name
    UNITS   // Units of measurement
  }
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| SVID | U1/U2/U4 | Status Variable ID |
| SVNAME | ASCII | Status Variable Name |
| UNITS | ASCII | Units of measurement |

**Note**: A:0 for SVNAME and UNITS indicates unknown SVID.

---

#### **S1F13R - Establish Communications Request** {#s1f13r---establish-communications-request}

**Equipment Send Format**:
```
S1F13-> or <-S1F13
{L[2]
  MDLN    // Equipment model name
  SOFTREV // Software revision
}
```

**Host Send Format**:
```
<-S1F13
L:0
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| MDLN | ASCII | Equipment model name |
| SOFTREV | ASCII | Software revision |

**Usage**: Initial communication establishment between host and equipment.

---

#### **S1F14 - Establish Communications Request Acknowledge** {#s1f14---establish-communications-request-acknowledge}

**Equipment Send Format**:
```
S1F14-> or <-S1F14
{L[2]
  COMMACK // Communication Acknowledge
  {L[2]
    MDLN    // Equipment model name
    SOFTREV // Software revision
  }
}
```

**Host Send Format**:
```
S1F14-> or <-S1F14
{L[2]
  COMMACK // Communication Acknowledge
  L:0
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| COMMACK | U1/U2/U4 | Communication Acknowledge code |
| MDLN | ASCII | Equipment model name |
| SOFTREV | ASCII | Software revision |

**Note**: MDLN and SOFTREV may not be valid unless COMMACK value is 0.

---

#### **S1F15R - Request OFF-LINE** {#s1f15r---request-offline}

```
<-S1F15
Header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Header only message |

**Usage**: Host requests equipment to enter offline state.

---

#### **S1F16 - OFF-LINE Acknowledge** {#s1f16---offline-acknowledge}

**Direction**: E → H  
**Description**: Acknowledge offline request

```
S1F16->
OFLACK   // Offline Acknowledge
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| OFLACK | U1/U2/U4 | Offline Acknowledge code |

---

#### **S1F17R - Request ON-LINE** {#s1f17r---request-online}

```
<-S1F17
Header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Header only message |

**Usage**: Host requests equipment to enter online state.

---

#### **S1F18 - ON-LINE Acknowledge** {#s1f18---online-acknowledge}

```
S1F18->
ONLACK   // Online Acknowledge
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| ONLACK | U1/U2/U4 | Online Acknowledge code |

---

#### **S1F19R - Get Attribute** {#s1f19r---get-attribute}

```
<-S1F19
{L[3]
  OBJTYPE // Object Type
  {L[m]
    OBJID  // Object ID list
  }
  {L[n]
    ATTRID // Attribute ID list
  }
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJTYPE | U1/U2/U4/A | Object Type |
| OBJID | List | Object ID list |
| ATTRID | List | Attribute ID list |

**Note**: L:m = L:0 for all objects, L[n] = L:0 for all attributes.

---

#### **S1F20 - Attribute Data** {#s1f20---attribute-data}

```
S1F20->
{L[2]
  {L[m]
    {L[n]
      ATTRDATA // Attribute Data
    }
  }
  {L[p]
    {L[2]
      ERRCODE  // Error Code
      ERRTEXT  // Error Text
    }
  }
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| ATTRDATA | Various | Attribute Data |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

**Note**: Ordered per request. m=0 means OBJTYPE unknown, n=0 means instance not found.

---

#### **S1F21R - Data Variable Namelist Request** {#s1f21r---data-variable-namelist-request}

```
<-S1F21
{L[n]
  VID     // Variable ID list
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| VID | List | Variable ID list (L:0 requests all DVVALs) |

**Note**: VIDs are limited to DVVAL variables only.

---

#### **S1F22 - Data Variable Namelist Reply** {#s1f22---data-variable-namelist-reply}

```
S1F22->
{L[n]
  {L[3]
    VID        // Variable ID
    DVVALNAME  // Data Variable Name
    UNITS      // Units of measurement
  }
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| VID | U1/U2/U4 | Variable ID |
| DVVALNAME | ASCII | Data Variable Name |
| UNITS | ASCII | Units of measurement |

**Note**: A:0 for DVVALNAME and UNITS indicates unknown VID or that VID is not a DVVAL.

---

#### **S1F23R - Collection Event Namelist Request** {#s1f23r---collection-event-namelist-request}

```
<-S1F23
{L[n]
  CEID    // Collection Event ID list
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | List | Collection Event ID list (L:0 implies all CEIDs) |

**Usage**: Host requests information about available collection events.

---

#### **S1F24 - Collection Event Namelist Reply** {#s1f24---collection-event-namelist-reply}

```
S1F24->
{L[n]
  {L[3]
    CEID   // Collection Event ID
    CENAME // Collection Event Name
    {L[a]
      VID   // Variable ID list
    }
  }
}
```

**Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | U1/U2/U4 | Collection Event ID |
| CENAME | ASCII | Collection Event Name |
| VID | List | Associated Variable ID list |

**Note**: Only associated DVVAL VIDs are listed. A:0 for CENAME and L:0 for L:a indicates non-existent CEID.


### Stream 2: Equipment Control and Diagnostics
**Purpose**: Equipment configuration and diagnostic operations

| Message | Direction | Description |
|---------|-----------|-------------|
| [S2F1](#s2f1---service-program-load-inquire)    | ↔ Equipment | Service Program Load Inquire |
| [S2F2](#s2f2---service-program-load-grant)    | ↔ Equipment | Service Program Load Grant |
| [S2F3](#s2f3---service-program-send)    | ↔ Equipment | Service Program Send |
| [S2F4](#s2f4---service-program-send-acknowledge)    | ↔ Equipment | Service Program Send Acknowledge |
| [S2F5](#s2f5---service-program-load-request)    | ↔ Equipment | Service Program Load Request |
| [S2F6](#s2f6---service-program-load-data)    | ↔ Equipment | Service Program Load Data |
| [S2F7](#s2f7---service-program-run-send)    | ↔ Equipment | Service Program Run Send |
| [S2F8](#s2f8---service-program-run-acknowledge)    | ↔ Equipment | Service Program Run Acknowledge |
| [S2F9](#s2f9---service-program-results-request)    | ↔ Equipment | Service Program Results Request |
| [S2F10](#s2f10---service-program-results-data)    | ↔ Equipment | Service Program Results Data |
| [S2F11](#s2f11---service-program-directory-request)    | ↔ Equipment | Service Program Directory Request |
| [S2F12](#s2f12---service-program-directory-data)    | ↔ Equipment | Service Program Directory Data |
| [S2F13](#s2f13---equipment-constant-request)    | → Equipment | Equipment Constant Request |
| [S2F14](#s2f14---equipment-constant-data)    | ← Equipment | Equipment Constant Data |
| [S2F15](#s2f15---new-equipment-constant-send)    | → Equipment | New Equipment Constant Send |
| [S2F16](#s2f16---new-equipment-constant-ack)    | ← Equipment | New Equipment Constant Ack |
| [S2F17](#s2f17---date-and-time-request)    | ↔ Equipment | Date and Time Request |
| [S2F18](#s2f18---date-and-time-data)    | ↔ Equipment | Date and Time Data |
| [S2F19](#s2f19---resetinitialize-send)    | → Equipment | Reset/Initialize Send |
| [S2F20](#s2f20---reset-acknowledge)    | ← Equipment | Reset Acknowledge |
| [S2F21](#s2f21---remote-command-send)    | → Equipment | Remote Command Send |
| [S2F22](#s2f22---remote-command-acknowledge)    | ← Equipment | Remote Command Acknowledge |
| [S2F23](#s2f23---trace-initialize-send)    | → Equipment | Trace Initialize Send |
| [S2F24](#s2f24---trace-initialize-acknowledge)    | ← Equipment | Trace Initialize Acknowledge |
| [S2F25](#s2f25---loopback-diagnostic-request)    | ↔ Equipment | Loopback Diagnostic Request |
| [S2F26](#s2f26---loopback-diagnostic-data)    | ↔ Equipment | Loopback Diagnostic Data |
| [S2F27](#s2f27---initiate-processing-request)    | → Equipment | Initiate Processing Request |
| [S2F28](#s2f28---initiate-processing-acknowledge)    | ← Equipment | Initiate Processing Acknowledge |
| [S2F29](#s2f29---equipment-constant-namelist-request)    | → Equipment | Equipment Constant Namelist Request |
| [S2F30](#s2f30---equipment-constant-namelist)    | ← Equipment | Equipment Constant Namelist |
| [S2F31](#s2f31---date-and-time-set-request)    | → Equipment | Date and Time Set Request |
| [S2F32](#s2f32---date-and-time-set-acknowledge)    | ← Equipment | Date and Time Set Acknowledge |
| [S2F33](#s2f33---define-report)    | → Equipment | Define Report |
| [S2F34](#s2f34---define-report-acknowledge)    | ← Equipment | Define Report Acknowledge |
| [S2F35](#s2f35---link-event-report)    | → Equipment | Link Event Report |
| [S2F36](#s2f36---link-event-report-acknowledge)    | ← Equipment | Link Event Report Acknowledge |
| [S2F37](#s2f37---enabledisable-event-report)    | → Equipment | Enable/Disable Event Report |
| [S2F38](#s2f38---enabledisable-event-report-acknowledge)    | ← Equipment | Enable/Disable Event Report Acknowledge |
| [S2F39](#s2f39---multi-block-inquire)    | → Equipment | Multi-block Inquire |
| [S2F40](#s2f40---multi-block-grant)    | ← Equipment | Multi-block Grant |
| [S2F41](#s2f41---host-command-send)    | → Equipment | Host Command Send |
| [S2F42](#s2f42---host-command-acknowledge)    | ← Equipment | Host Command Acknowledge |
| [S2F43](#s2f43---configure-spooling)    | → Equipment | Configure Spooling |
| [S2F44](#s2f44---configure-spooling-acknowledge)    | ← Equipment | Configure Spooling Acknowledge |
| [S2F45](#s2f45---define-variable-limit-attributes)    | → Equipment | Define Variable Limit Attributes |
| [S2F46](#s2f46---define-variable-limit-attributes-acknowledge)    | ← Equipment | Define Variable Limit Attributes Acknowledge |
| [S2F47](#s2f47---variable-limit-attribute-request)    | → Equipment | Variable Limit Attribute Request |
| [S2F48](#s2f48---variable-limit-attribute-send)    | ← Equipment | Variable Limit Attribute Send |
| [S2F49](#s2f49---enhanced-remote-command)    | → Equipment | Enhanced Remote Command |
| [S2F50](#s2f50---enhanced-remote-command-acknowledge)    | ← Equipment | Enhanced Remote Command Acknowledge |
| [S2F51](#s2f51---request-report-identifiers)    | → Equipment | Request Report Identifiers |
| [S2F52](#s2f52---return-report-identifiers)    | ← Equipment | Return Report Identifiers |
| [S2F53](#s2f53---request-report-definitions)    | → Equipment | Request Report Definitions |
| [S2F54](#s2f54---return-report-definitions)    | ← Equipment | Return Report Definitions |
| [S2F55](#s2f55---request-event-report-links)    | → Equipment | Request Event Report Links |
| [S2F56](#s2f56---return-event-report-links)    | ← Equipment | Return Event Report Links |
| [S2F57](#s2f57---request-enabled-events)    | → Equipment | Request Enabled Events |
| [S2F58](#s2f58---return-enabled-events)    | ← Equipment | Return Enabled Events |
| [S2F59](#s2f59---request-spool-streams-and-functions)    | → Equipment | Request Spool Streams and Functions |
| [S2F60](#s2f60---return-spool-streams-and-functions)    | ← Equipment | Return Spool Streams and Functions |
| [S2F61](#s2f61---request-trace-identifiers)    | → Equipment | Request Trace Identifiers |
| [S2F62](#s2f62---return-trace-identifiers)    | ← Equipment | Return Trace Identifiers |
| [S2F63](#s2f63---request-trace-definitions)    | → Equipment | Request Trace Definitions |
| [S2F64](#s2f64---return-trace-definitions)    | ← Equipment | Return Trace Definitions |

#### **S2F1 - Service Program Load Inquire** {#s2f1---service-program-load-inquire}
```
↔S2F1
{L[2]
  SPID
  LENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPID | ASCII | Service Program ID |
| LENGTH | U4 | Length of service program |

#### **S2F2 - Service Program Load Grant** {#s2f2---service-program-load-grant}
```
↔S2F2
GRANT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | U1 | Grant code |

| Parameter | Type | Description |
|-----------|------|-------------|
| SV | Various | Status Variable Value (corresponding to SVID in S2F1) |


#### **S2F3 - Service Program Send** {#s2f3---service-program-send}
```
↔S2F3
SPD
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPD | Binary | Service Program Data |


#### **S2F4 - Service Program Send Acknowledge** {#s2f4---service-program-send-acknowledge}
```
↔S2F4
SPAACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPAACK | U1 | Service Program Acknowledge |


#### **S2F5 - Service Program Load Request** {#s2f5---service-program-load-request}
```
↔S2F5
SPID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPID | ASCII | Service Program ID |


#### **S2F6 - Service Program Load Data** {#s2f6---service-program-load-data}
```
↔S2F6
SPD
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPD | Binary | Service Program Data |


#### **S2F7 - Service Program Run Send** {#s2f7---service-program-run-send}
```
↔S2F7
SPID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPID | ASCII | Service Program ID |


#### **S2F8 - Service Program Run Acknowledge** {#s2f8---service-program-run-acknowledge}
```
↔S2F8
CSAACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CSAACK | U1 | Command Service Acknowledge |
| PORTSTATUS | U1/U2/U4/A | Port Status |


#### **S2F9 - Equipment Status Multi-Block Inquire** {#s2f9---equipment-status-multi-block-inquire}
```
<-S2F9
{L[n]
  SVID_1
  SVID_2
  ...
  SVID_n
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SVID | U1/U2/U4/A | Status Variable ID |


#### **S2F10 - Equipment Status Multi-Block Grant** {#s2f10---equipment-status-multi-block-grant}
```
S2F10->
GRANT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | U1/U2/U4/A | Grant permission for multi-block transfer |


#### **S2F11 - Equipment Status Multi-Block** {#s2f11---equipment-status-multi-block}
```
S2F11->
{L[n]
  SV_1
  SV_2
          ...
  SV_n
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SV | Various | Status Variable Value (corresponding to SVID in S2F9) |


#### **S2F12 - Equipment Status Multi-Block Acknowledge** {#s2f12---equipment-status-multi-block-acknowledge}
```
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (acknowledgment) |


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

| Parameter | Type | Description |
|-----------|------|-------------|
| ECID | U1/U2/U4/A | Equipment Constant ID |


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

| Parameter | Type | Description |
|-----------|------|-------------|
| ECV | Various | Equipment Constant Value (corresponding to ECID in S2F13) |


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

| Parameter | Type | Description |
|-----------|------|-------------|
| ECID | U1/U2/U4/A | Equipment Constant ID |
| ECV | U1/U2/U4/A | Equipment Constant Value |


#### **S2F16 - New Equipment Constant Acknowledge** {#s2f16---new-equipment-constant-acknowledge}
```
EAC
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EAC | U1/U2/U4/A | Equipment Acknowledge Code |


#### **S2F17 - Date and Time Request** {#s2f17---date-and-time-request}
```
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| - | - | Empty list (request for current date and time) |


#### **S2F18 - Date and Time Response** {#s2f18---date-and-time-response}
```
TIME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIME | A | Date and Time value |


#### **S2F19 - Recipe Body Request** {#s2f19---recipe-body-request}
```
  {L[2]
    RCMD
    RPARM
  }
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RCMD | A | Recipe Command |
| RPARM | A | Recipe Parameter |


#### **S2F20 - Recipe Body Response** {#s2f20---recipe-body-response}
```
{L[2]
  RCMD
  RPARM
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RCMD | A | Recipe Command |
| RPARM | A | Recipe Parameter |


#### **S2F21 - Recipe Body Send** {#s2f21---recipe-body-send}
```
{L[2]
  RCMD
  RPARM
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RCMD | A | Recipe Command |
| RPARM | A | Recipe Parameter |


#### **S2F22 - Recipe Body Acknowledge** {#s2f22---recipe-body-acknowledge}
```
CMDA
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CMDA | A | Command Acknowledge |


# S2F23 (FDC) Overview

Fault Detection and Classification (FDC) is a process in semiconductor manufacturing that collects and analyzes data in real-time to detect and classify equipment anomalies. The S2F23 message defines a scenario where the host requests periodic data collection from the equipment, and the equipment collects and reports the data accordingly.

## 1. Scenario Initiation: Host Request (S2F23 Transmission)
- The **host** sends an S2F23 message to the equipment to request monitoring of specific Status Variables (SVs). The message includes the following information:
  - **TRID (Trace ID)**: A unique identifier for the trace request.
  - **SVID (Status Variable ID)**: Identifier for the status variable to monitor (e.g., temperature, pressure, wafer status).
  - **DSPER (Data Sampling Period)**: Data sampling interval (e.g., every 1 second).
  - **TOTSMP (Total Samples)**: Total number of samples to collect.
  - **REPGSZ (Report Group Size)**: Number of data points included in each report.
- **Example**: The host requests the equipment to collect temperature data every 1 second for 100 samples, reporting every 10 samples.

## 2. Equipment Response
- The equipment receives the S2F23 message, validates the requested conditions, and responds with an S2F24 message indicating acceptance or rejection.
  - **Acceptance**: The equipment starts data collection based on the requested conditions.
  - **Rejection**: The equipment responds with the reason it cannot process the request (e.g., invalid SVID, insufficient resources).

## 3. Data Collection and Reporting (S6F1 Transmission)
- The equipment collects data according to the specified DSPER.
- Upon reaching REPGSZ (e.g., 10 samples collected), the equipment sends the collected data to the host via an **S6F1** message.
- The S6F1 message includes the TRID and the collected data values.
- To reduce network traffic, data is aggregated and sent in batches, with each report consisting of SVIDs and their corresponding values.
- **Example**: Temperature data is sent via S6F1 every time 10 samples are collected.

## 4. Integration with FDC Process
- The host receives the S6F1 data and analyzes it using FDC software.
- The FDC system detects anomalies (e.g., temperature spikes, pressure fluctuations) based on the collected data and, if necessary, triggers alarms or instructs the equipment to halt the process.
- **Example**: If temperature data exceeds a predefined threshold, the host may send a warning message (e.g., S10F3) to the equipment or request an operator notification.

## 5. Scenario Termination
- Once the equipment reaches TOTSMP (total samples), it terminates data collection and sends the final data via S6F1.
- The host may send a new S2F23 request to continue monitoring or cancel the existing TRID using S2F25 to stop monitoring.

#### **S2F23 - Trace Initialize Send** {#s2f23---trace-initialize-send}
```
S2F23->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | A | Trace ID |
| DSPER | U1/U2/U4 | Display Period |
| TOTSMP | U1/U2/U4 | Total Samples |
| REPGSZ | U1/U2/U4 | Report Page Size |
| SVID | U1/U2/U4/A | Status Variable ID |


#### **S2F24 - Trace Initialize Acknowledge** {#s2f24---trace-initialize-acknowledge}
```
<-S2F24
TIAACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIAACK | B[1] | Trace Initialize Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F25 - Loopback Diagnostic Request** {#s2f25---loopback-diagnostic-request}
```
<-S2F25
ABS
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ABS | B | Arbitrary Binary String |


#### **S2F26 - Loopback Diagnostic Response** {#s2f26---loopback-diagnostic-response}
```
S2F26->
ABS
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ABS | B | Arbitrary Binary String |


#### **S2F27 - Initiate Processing Request** {#s2f27---initiate-processing-request}
```
<-S2F27
{L[3]
  LOC
  PPID
  {L[n]
    MID
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| LOC | A | Location |
| PPID | A | Process Program ID |
| MID | A | Material ID |


#### **S2F28 - Initiate Processing Acknowledge** {#s2f28---initiate-processing-acknowledge}
```
S2F28->
CMDA
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CMDA | A | Command Acknowledge |


#### **S2F29 - Equipment Constant Namelist Request** {#s2f29---equipment-constant-namelist-request}
```
<-S2F29
{L[n]
  ECID_1
  ECID_2
  ...
  ECID_n
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ECID | U1/U2/U4/A | Equipment Constant ID |


#### **S2F30 - Equipment Constant Namelist Response** {#s2f30---equipment-constant-namelist-response}
```
S2F30->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| ECID | U1/U2/U4/A | Equipment Constant ID |
| ECNAME | A | Equipment Constant Name |
| ECMIN | U1/U2/U4/A | Equipment Constant Minimum Value |
| ECMAX | U1/U2/U4/A | Equipment Constant Maximum Value |
| ECDEF | U1/U2/U4/A | Equipment Constant Default Value |
| UNITS | A | Units |


#### **S2F31 - Date and Time Set Request** {#s2f31---date-and-time-set-request}
```
<-S2F31
TIME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIME | A | Date and Time value |


#### **S2F32 - Date and Time Set Response** {#s2f32---date-and-time-set-response}
```
S2F32->
TIACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIACK | B[1] | Time Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F33 - Define Report** {#s2f33---define-report}
```
<-S2F33
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| RPTID | U1/U2/U4/A | Report ID |
| VID | U1/U2/U4/A | Variable ID |


#### **S2F34 - Define Report Acknowledge** {#s2f34---define-report-acknowledge}
```
S2F34->
DRACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DRACK | B[1] | Define Report Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F35 - Link Event Report** {#s2f35---link-event-report}
```
S2F35->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| RPTID | U1/U2/U4/A | Report ID |


#### **S2F36 - Link Event Report Acknowledge** {#s2f36---link-event-report-acknowledge}
```
<-S2F36
LRACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| LRACK | B[1] | Link Event Report Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F37 - Enable/Disable Event Report** {#s2f37---enabledisable-event-report}
```
<-S2F37
{L[2]
  CEED
  {L[n]
    CEID
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CEED | U1/U2/U4/A | Collection Event Enable/Disable |
| CEID | U1/U2/U4/A | Collection Event ID |


#### **S2F38 - Enable/Disable Event Report Acknowledge** {#s2f38---enabledisable-event-report-acknowledge}
```
S2F38->
ERACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ERACK | B[1] | Event Report Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F39 - Status Variable Namelist Request** {#s2f39---status-variable-namelist-request}
```
<-S2F39
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| DATALENGTH | U1/U2/U4 | Data Length |


#### **S2F40 - Status Variable Namelist Response** {#s2f40---status-variable-namelist-response}
```
S2F40->
GRANT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | - | Grant permission for multi-block transfer |


#### **S2F41 - Host Command Send** {#s2f41---host-command-send}
```
<-S2F41
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RCMD | A | Remote Command |
| CPNAME | A | Command Parameter Name |
| CPVAL | A | Command Parameter Value |


#### **S2F42 - Host Command Acknowledge** {#s2f42---host-command-acknowledge}
```
S2F42->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| HCACK | B[1] | Host Command Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |
| CPNAME | A | Command Parameter Name |
| CPACK | B[1] | Command Parameter Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F43 - Reset Spooling Streams and Functions** {#s2f43---reset-spooling-streams-and-functions}
```
<-S2F43
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

| Parameter | Type | Description |
|-----------|------|-------------|
| STRID | U1/U2/U4/A | Stream ID |
| FCNID | U1/U2/U4/A | Function ID |


#### **S2F44 - Reset Spooling Acknowledge** {#s2f44---reset-spooling-acknowledge}
```
S2F44->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RSPACK | B[1] | Reset Spooling Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |
| STRID | U1/U2/U4/A | Stream ID |
| STRACK | B[1] | Stream Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |
| FCNID | U1/U2/U4/A | Function ID |


#### **S2F45 - Define Variable Limit Attributes** {#s2f45---define-variable-limit-attributes}
```
<-S2F45
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| VID | U1/U2/U4/A | Variable ID |
| LIMITID | U1/U2/U4/A | Limit ID |
| UPPERDB | U1/U2/U4/A | Upper Database |
| LOWERDB | U1/U2/U4/A | Lower Database |


#### **S2F46 - Define Variable Limit Attributes Acknowledge** {#s2f46---define-variable-limit-attributes-acknowledge}
```
S2F46->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| VLAACK | B[1] | Variable Limit Attributes Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |
| VID | U1/U2/U4/A | Variable ID |
| LVACK | B[1] | Limit Value Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |
| LIMITID | U1/U2/U4/A | Limit ID |
| LIMITACK | B[1] | Limit Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F47 - Variable Limit Attribute Request** {#s2f47---variable-limit-attribute-request}
```
<-S2F47
{L[n]
  VID_1
  VID_2
  ...
  VID_n
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| VID | U1/U2/U4/A | Variable ID |


#### **S2F48 - Variable Limit Attribute Response** {#s2f48---variable-limit-attribute-response}
```
S2F48->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| VID | U1/U2/U4/A | Variable ID |
| UNITS | A | Units |
| LIMITMIN | U1/U2/U4/A | Limit Minimum |
| LIMITMAX | U1/U2/U4/A | Limit Maximum |
| LIMITID | U1/U2/U4/A | Limit ID |
| UPPERDB | U1/U2/U4/A | Upper Database |
| LOWERDB | U1/U2/U4/A | Lower Database |


#### **S2F49 - Enhanced Remote Command** {#s2f49---enhanced-remote-command}
```
<-S2F49
{L[4]
  RCMD
      CPNAME
  CEPVAL
      CPACK
    }
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RCMD | A | Remote Command |
| CPNAME | A | Command Parameter Name |
| CEPVAL | A | Command Parameter Value |
| CPACK | B[1] | Command Parameter Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F50 - Enhanced Remote Command Acknowledge** {#s2f50---enhanced-remote-command-acknowledge}
```
S2F50->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| HCACK | B[1] | Host Command Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |
| CPNAME | A | Command Parameter Name |
| CEPACK | B[1] | Command Parameter Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |


#### **S2F51 - Request Report Identifiers** {#s2f51---request-report-identifiers}
```
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Header only message |
 


#### **S2F52 - Return Report Identifiers** {#s2f52---return-report-identifiers}
```
S2F52->
{L[n]
  RPTID
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U1, U2, U4, or A | Report ID |


#### **S2F53 - Request Report Definitions** {#s2f53---request-report-definitions}
```
<-S2F53
{L[n]
  RPTID
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U1, U2, U4, or A | Report ID |


#### **S2F54 - Return Report Definitions** {#s2f54---return-report-definitions}
```
S2F54->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U1, U2, U4, or A | Report ID |
| VID | U1, U2, U4, or A | Variable ID |


#### **S2F55 - Request Event Report Links** {#s2f55---request-event-report-links}
```
<-S2F55
{L[n]
  CEID
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | U1, U2, U4, or A | Collection Event ID |


#### **S2F56 - Return Event Report Links** {#s2f56---return-event-report-links}
```
S2F56->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | U1, U2, U4, or A | Collection Event ID |
| CENAME | A | Collection Event Name |
| RPTID | U1, U2, U4, or A | Report ID |


#### **S2F57 - Request Enabled Events** {#s2f57---request-enabled-events}
```
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) |
 

#### **S2F58 - Return Enabled Events** {#s2f58---return-enabled-events}
```
S2F58->
{L[n]
  CEID
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | U1, U2, U4, or A | Collection Event ID |


#### **S2F59 - Request Spool Streams and Functions** {#s2f59---request-spool-streams-and-functions}
```
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) |


#### **S2F60 - Return Spool Streams and Functions** {#s2f60---return-spool-streams-and-functions}
```
S2F60->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| STRID | U1, U2, U4, or A | Stream ID |
| FCNID | U1, U2, U4, or A | Function ID |


#### **S2F61 - Request Trace Identifiers** {#s2f61---request-trace-identifiers}
```
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) |
 

#### **S2F62 - Return Trace Identifiers** {#s2f62---return-trace-identifiers}
```
S2F62->
{L[n]
  TRID
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | A | Trace ID |


#### **S2F63 - Request Trace Definitions** {#s2f63---request-trace-definitions}
```
<-S2F63
{L[n]
  TRID
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | A | Trace ID |


#### **S2F64 - Return Trace Definitions** {#s2f64---return-trace-definitions}
```
S2F64->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | A | Trace ID |
| DSPER | U1, U2, U4 | Display Period |
| TOTSMP | U1, U2, U4 | Total Samples |
| REPGSZ | U1, U2, U4 | Report Page Size |
| SVID | U1, U2, U4, or A | Status Variable ID |



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
| [S3F20](#s3f20---cancel-all-carrier-out-ack)   | ← Equipment | Cancel All Carrier Out Ack |
| [S3F21](#s3f21---port-group-defn)   | → Equipment | Port Group Defn |
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
<-S3F1
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) | 

#### **S3F2 - Material Status Data** {#s3f2---material-status-data}
```
S3F2->
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
<-S3F3
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) | 

#### **S3F4 - Time to Completion Data** {#s3f4---time-to-completion-data}
```
S3F4->
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
S3F5->
{L[2]
  MF
  QUA
}

``` 

#### **S3F6 - Material Found Acknowledge** {#s3f6---material-found-acknowledge}
```
<-S3F6
ACKC3
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC3 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S3F7 - Material Lost Send** {#s3f7---material-lost-send}
```
S3F7->
{L[3]
  MF
  QUA
  MID
}

``` 

#### **S3F8 - Material Lost Ack** {#s3f8---material-lost-ack}
```
S3F8->
ACKC3
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC3 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S3F9 - Matl ID Equate Send** {#s3f9---matl-id-equate-send}
```

S3F9->
{L[2]
  MID
  EMID
}


``` 

#### **S3F10 - Port Status Acknowledge** {#s3f10---port-status-acknowledge}
```
<-S3F10
ACKC3
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC3 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S3F11 - Matl ID Request** {#s3f11---matl-id-request}
```
<-S3F11
{
  PTN
}
```

#### **S3F12 - Matl ID Request Ack** {#s3f12---matl-id-request-ack}
```
S3F12->
{L[3]
  PTN
  MIDRA
  MID
} 
```
 

#### **S3F13 - Matl ID Send** {#s3f13---matl-id-send}
```
S3F13->
{L[2]
  PTN
  MID
}
``` 

#### **S3F14 - Matl ID Ack** {#s3f14---matl-id-ack}
```
<-S3F14
{
  MIDAC
}

```
 
#### **S3F15 - Matls Multi-block Inquire(SECS-I)** {#s3f15---matls-multi-block-inquire}
```
<-S3F15
{L[2]
  DATAID
  DATALENGTH
}
``` 

#### **S3F16 - Matls Multi-block Grant** {#s3f16---matls-multi-block-grant}
```
S3F16->
{
  GRANT
}

``` 

# S3F17 (Carrier Action Request) Overview

The S3F17 message is an unsolicited message sent by the equipment to inform the host about the receipt of new material (e.g., wafers, carriers, pods). This message shares material identification and status information, enabling the host to manage process flow and track materials.

## 1. Scenario Initiation: Material Receipt
- The equipment receives new material, such as:
  - A FOUP (Front Opening Unified Pod) or carrier placed at a load port.
  - Wafers or other materials loaded into the equipment.
- The equipment reads the material’s unique identification information (e.g., carrier ID, lot ID) and verifies its status.
- This process may involve automated load ports, RFID, or barcode readers.

## 2. S3F17 Message Transmission
- Upon detecting material receipt, the equipment sends an **S3F17** message to the host to report material information.
- The S3F17 message includes:
  - **CARRIERID**: Unique identifier for the material carrier (e.g., FOUP ID).
  - **LOTID**: Unique identifier for the lot contained in the material (optional, used for lot-based management).
  - **SLOTMAP**: Material placement information within the carrier (e.g., slot numbers mapped to wafer IDs).
  - **PORTID**: Identifier for the port where the material was loaded (e.g., load port number).
  - **TIMESTAMP**: Time of material receipt (optional).
- **Example**: If the equipment receives a FOUP (carrier ID: F123) at load port 1 with 25 wafers, the S3F17 message reports CARRIERID="F123", PORTID="1", SLOTMAP={1:Wafer1, 2:Wafer2, ...}.

## 3. Host Response
- The host receives the S3F17 message and verifies the material information.
- Based on the received data, the host performs the following actions:
  - **Material Tracking**: Updates the Manufacturing Execution System (MES) with material information to manage process flow.
  - **Validation**: Ensures CARRIERID, LOTID, and SLOTMAP align with process requirements (e.g., correct lot, expected wafer count).
  - **Task Instruction**: If the material is correctly received, the host sends a process start command (e.g., S2F41) or schedules subsequent tasks.
- The host may respond with an S3F18 message to acknowledge S3F17 receipt or provide further instructions.
- **Example**: The host confirms FOUP details via S3F17 and specifies the process recipe for the lot.

## 4. Error Handling
- If the S3F17 message contains incorrect information (e.g., unknown CARRIERID), the host detects the error and may request additional information or issue a warning.
- If the equipment fails to receive material (e.g., FOUP load error), it may report this via other SECS messages (e.g., S10F3, Terminal Display).
- **Example**: If the host receives an unexpected LOTID in S3F17, it may check equipment status via S2F13 or notify an operator.

## 5. Scenario Termination
- Once the host successfully processes the material information and prepares for the process, the material receipt scenario concludes.
- The equipment processes the material per host instructions (e.g., starts wafer processing) or awaits further material receipts.
- The host may continue tracking material status or request a material sent report (S3F19) after process completion.

## S3F17 Scenario Characteristics
- **Unsolicited Message**: The equipment proactively reports material receipt without prior host request.
- **Material Management**: Tracks the location and status of materials (wafers, carriers) in real-time during semiconductor processing.
- **Standardization**: Complies with SEMI E5 and E30 (GEM) standards, ensuring compatibility across equipment and hosts.
- **Automation Support**: Enhances process automation through integration with load ports and MES.

## Example Flow
1. A FOUP (carrier ID: F123) with 25 wafers is placed at load port 1 of the equipment.
2. The equipment reads FOUP information and sends an S3F17 message (CARRIERID="F123", PORTID="1", SLOTMAP={1:Wafer1, ...}).
3. The host receives S3F17 and updates material information in the MES.
4. The host verifies the process recipe and sends an S2F41 command to start processing.
5. The equipment begins processing, concluding the scenario.

#### **S3F17 - Carrier Action Request (Extended)** {#s3f17---carrier-action-request-extended}
```
<-S3F17
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CARRIERACTION | U1 | Carrier Action |
| CARRIERID | A | Carrier ID |
| PTN | U1 | Port Number |
| CATTRID | U1/U2/U4/A | Carrier Attribute ID |
| CATTRDATA | any format | Carrier Attribute Data |

#### **S3F18 - Carrier Action Response (Extended)** {#s3f18---carrier-action-response-extended}
```
S3F18->
{L[2]
  DATAID
  CAACK
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | - | Data ID (matching request) |
| CAACK | U1 | Carrier Action Acknowledge |
| | | 0: Acknowledged |
| | | 1: Denied, Invalid Command |
| | | 2: Denied, Cannot Perform Now |

#### **S3F19 - Port Action Request** {#s3f19---port-action-request}
```
<-S3F19
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| PORTACTION | U1 | Port Action |
| | | 1: Open |
| | | 2: Close |
| | | 3: Lock |
| | | 4: Unlock |
| PTN | U1 | Port Number |
| PATTRID | U1/U2/U4/A | Port Attribute ID |
| PATTRDATA | any format | Port Attribute Data |

#### **S3F20 - Cancel All Carrier Out Ack** {#s3f20---cancel-all-carrier-out-ack}
```
S3F20->
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
<-S3F21
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
S3F22->
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
<-S3F23
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
S3F24->
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
<-S3F25
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
S3F26->
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
<-S3F27
{L[2]
  ACCESSMODE
  {L[n]
  PTN
  }
}
``` 

#### **S3F28 - Change Access Ack** {#s3f28---change-access-ack}
```
S3F28->
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
<-S3F29
{L[4]
  LOCID
  CARRIERSPEC
  DATASEG
  DATALENGTH
}
``` 
#### **S3F30 - Carrier Tag Read Data** {#s3f30---carrier-tag-read-data}
```
S3F30->
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

<-S3F31
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
S3F32->
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
<-S3F33
{}

``` 

#### **S3F34 - Cancel All Pod Out Ack** {#s3f34---cancel-all-pod-out-ack}
```
S3F34->
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
<-S3F35
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
S3F36->
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
<-S4F1
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F2 - Ready to Send Acknowledge** {#s4f2---ready-to-send-acknowledge}
```
S4F2->
RSACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RSACK | B[1] | Ready to Send Acknowledge |
| | | 0: Acknowledged |
| | | 1: Not ready |

#### **S4F3 - Send Material** {#s4f3---send-material}
```
<-S4F3
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F5 - Handshake Complete** {#s4f5---handshake-complete}
```
S4F5->
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F7 - Not Ready to Send** {#s4f7---not-ready-to-send}
```
S4F7->
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F9 - Stuck in Sender** {#s4f9---stuck-in-sender}
```
S4F9->
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F11 - Stuck in Receiver** {#s4f11---stuck-in-receiver}
```
S4F11->
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F13 - Send Incomplete Timeout** {#s4f13---send-incomplete-timeout}
```
S4F13->
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F15 - Material Received** {#s4f15---material-received}
```
S4F15->
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F17 - Request to Receive** {#s4f17---request-to-receive}
```
<-S4F17
{L[2]
  PTN
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PTN | U1 | Port Number |
| MID | A | Material ID |

#### **S4F18 - Request to Receive Acknowledge** {#s4f18---request-to-receive-acknowledge}
```
S4F18->
RRACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RRACK | B[1] | Request to Receive Acknowledge |
| | | 0: Acknowledged |
| | | 1: Not ready |

#### **S4F19 - Transfer Job Create** {#s4f19---transfer-job-create}
```
<-S4F19
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| TRJOBNAME | A | Transfer Job Name |
| TRLINK | U1 | Transfer Link |
| TRPORT | U1 | Transfer Port |
| TROBJNAME | A | Transfer Object Name |
| TROBJTYPE | A | Transfer Object Type |
| TRROLE | A | Transfer Role |
| TRRCP | A | Transfer RCP |
| TRPTNR | A | Transfer Partner |
| TRPTPORT | U1 | Transfer Partner Port |
| TRDIR | A | Transfer Direction |
| TRTYPE | A | Transfer Type |
| TRLOCATION | A | Transfer Location |
| TRAUTOSTART | B[1] | Transfer Auto Start |

#### **S4F20 - Transfer Job Acknowledge** {#s4f20---transfer-job-acknowledge}
```
S4F20->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRJOBID | A | Transfer Job ID |
| TRATOMCID | A | Transfer Atomic ID |
| TRACK | B[1] | Transfer Acknowledge |
| ERRCODE | U1 | Error Code |
| ERRTEXT | A | Error Text |

#### **S4F21 - Transfer Job Command** {#s4f21---transfer-job-command}
```
<-S4F21
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRJOBID | A | Transfer Job ID |
| TRCMDNAME | A | Transfer Command Name |
| CPNAME | A | Command Parameter Name |
| CPVAL | any format | Command Parameter Value |

#### **S4F22 - Transfer Job Command Acknowledge** {#s4f22---transfer-job-command-acknowledge}
```
S4F22->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRACK | B[1] | Transfer Acknowledge |
| ERRCODE | U1 | Error Code |
| ERRTEXT | A | Error Text |

#### **S4F23 - Transfer Command Alert** {#s4f23---transfer-command-alert}
```
S4F23->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRJOBID | A | Transfer Job ID |
| TRJOBNAME | A | Transfer Job Name |
| TRJOBMS | A | Transfer Job Message |
| TRACK | B[1] | Transfer Acknowledge |
| ERRCODE | U1 | Error Code |
| ERRTEXT | A | Error Text |

#### **S4F24 - Transfer Alert Acknowledge** {#s4f24---transfer-alert-acknowledge}
```
<-S4F24
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header only | - | Header only message |

#### **S4F25 - Multi-block Inquire** {#s4f25---multi-block-inquire}
```
<-S4F25
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| DATALENGTH | U4 | Data Length |

#### **S4F26 - Multi-block Grant** {#s4f26---multi-block-grant}
```
S4F26->
GRANT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | B[1] | Grant signal |
| | | 0: Not granted |
| | | 1: Granted |

#### **S4F27 - Handoff Ready** {#s4f27---handoff-ready}
```
S4F27->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| EQNAME | A | Equipment Name |
| TRLINK | U1 | Transfer Link |
| TRPORT | U1 | Transfer Port |
| TROBJNAME | A | Transfer Object Name |
| TROBJTYPE | A | Transfer Object Type |
| TRROLE | A | Transfer Role |
| TRPTNR | A | Transfer Partner |
| TRPTPORT | U1 | Transfer Partner Port |
| TRDIR | A | Transfer Direction |
| TRTYPE | A | Transfer Type |
| TRLOCATION | A | Transfer Location |

#### **S4F29 - Handoff Command** {#s4f29---handoff-command}
```
<-S4F29
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |
| MCINDEX | U1 | Machine Control Index |
| HOCMDNAME | A | Handoff Command Name |
| CPNAME | A | Command Parameter Name |
| CPVAL | any format | Command Parameter Value |

#### **S4F31 - Handoff Command Complete** {#s4f31---handoff-command-complete}
```
S4F31->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |
| MCINDEX | U1 | Machine Control Index |
| HOACK | B[1] | Handoff Acknowledge |
| ERRCODE | U1 | Error Code |
| ERRTEXT | A | Error Text |

#### **S4F33 - Handoff Verified** {#s4f33---handoff-verified}
```
S4F33->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |
| HOACK | B[1] | Handoff Acknowledge |
| ERRCODE | U1 | Error Code |
| ERRTEXT | A | Error Text |

#### **S4F35 - Handoff Cancel Ready** {#s4f35---handoff-cancel-ready}
```
S4F35->
TRLINK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |

#### **S4F37 - Handoff Cancel Ready Acknowledge** {#s4f37---handoff-cancel-ready-acknowledge}
```
<-S4F37
{L[2]
  TRLINK
  HOCANCELACK
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |
| HOCANCELACK | B[1] | Handoff Cancel Acknowledge |

#### **S4F39 - Handoff Halt** {#s4f39---handoff-halt}
```
S4F39->
TRLINK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |

#### **S4F41 - Handoff Halt Acknowledge** {#s4f41---handoff-halt-acknowledge}
```
<-S4F41
{L[2]
  TRLINK
  HOHALTACK
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRLINK | U1 | Transfer Link |
| HOHALTACK | B[1] | Handoff Halt Acknowledge |


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
S5F1->
{L[3]
  ALCD
  ALID
  ALTX
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ALCD | B[1] | Alarm Code |
| | | Bit 0: Alarm Set (1) or Clear (0) |
| | | Bit 7: Alarm (1) or Warning (0) |
| ALID | U1/U2/U4/A | Alarm ID |
| ALTX | A[120] | Alarm Text |

#### **S5F2 - Alarm Report Acknowledge** {#s5f2---alarm-report-acknowledge}
```
<-S5F2
ACKC5
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC5 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S5F3 - Enable/Disable Alarm Send** {#s5f3---enabledisable-alarm-send}
```

<-S5F3
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ALED | B[1] | Alarm Enable/Disable |
| | | 128 (0x80): Enable |
| | | 0: Disable |
| ALID | U1, U2, U4, or A | Alarm ID |
```

#### **S5F4 - Enable/Disable Alarm Acknowledge** {#s5f4---enabledisable-alarm-acknowledge}
```

S5F4->
ACKC5

```
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC5 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
```

#### **S5F5 - List Alarms Request** {#s5f5---list-alarms-request}
```
<-S5F5
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) |

#### **S5F6 - List Alarms Response** {#s5f6---list-alarms-response}
```
S5F6->
{L[n]
  ALID_1
  ALID_2
  ...
  ALID_n
}
``` 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ALID | U1, U2, U4, or A | Alarm ID |


#### **S5F7 - List Enabled Alarm Request** {#s5f7---list-enabled-alarm-request}
```
<-S5F7
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Empty list (header only message) |

#### **S5F8 - List Enabled Alarm Response** {#s5f8---list-enabled-alarm-response}
```
S5F8->
{L[n]
  ALID_1
  ALID_2
  ...
  ALID_n
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ALID | U1, U2, U4, or A | Alarm ID - Only enabled alarms |


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
S6F1->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U1, U2, U4, or A | Trace Request ID |
| SMPLN | U1, U2, U4 | Sample Number |
| STIME | A | Sample Time |
| SV | any format | Sample Value |

#### **S6F2 - Trace Data Acknowledge** {#s6f2---trace-data-acknowledge}
```
<-S6F2
ACKC6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC6 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S6F3 - Discrete Variable Data Send** {#s6f3---discrete-variable-data-send}
```
S6F3->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| CEID | U1, U2, U4, or A | Collection Event ID |
| DSID | U1, U2, U4, or A | Data Set ID |
| DVNAME | A | Discrete Variable Name |
| DVVAL | any format | Discrete Variable Value |

#### **S6F4 - Discrete Variable Data Acknowledge** {#s6f4---discrete-variable-data-acknowledge}
```
<-S6F4
ACKC6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC6 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S6F5 - Multi-block Data Send Inquire** {#s6f5---multi-block-data-send-inquire}
```
S6F5->
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| DATALENGTH | U4 | Data Length |

#### **S6F6 - Multi-block Grant** {#s6f6---multi-block-grant}
```
<-S6F6
GRANT6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT6 | B[1] | Grant Code |
| | | 0: Granted |
| | | 1: Busy, try again |
| | | 2: No space |

#### **S6F7 - Data Transfer Request** {#s6f7---data-transfer-request}
```
<-S6F7
DATAID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |

#### **S6F8 - Data Transfer Data** {#s6f8---data-transfer-data}
```
S6F8->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| DSID | U1/U2/U4/A | Data Set ID |
| DVNAME | A | Discrete Variable Name |
| DVVAL | any format | Discrete Variable Value |

#### **S6F9 - Formatted Variable Send** {#s6f9---formatted-variable-send}
```
<-S6F9
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

| Parameter | Type | Description |
|-----------|------|-------------|
| PFCD | A | Process Function Code |
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| DSID | U1/U2/U4/A | Data Set ID |
| DVVAL | any format | Discrete Variable Value |

#### **S6F10 - Formatted Variable Acknowledge** {#s6f10---formatted-variable-acknowledge}
```
S6F10->
ACKC6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC6 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S6F11 - Event Report Send** {#s6f11---event-report-send}
```
S6F11->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| RPTID | U1/U2/U4/A | Report ID |
| V | any format | Variable Value |

#### **S6F12 - Event Report Acknowledge** {#s6f12---event-report-acknowledge}
```
ACKC6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC6 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| RPTID | U1/U2/U4/A | Report ID |
| VID | U1/U2/U4/A | Variable ID |
| V | any format | Variable Value |

#### **S6F14 - Annotated Event Report Acknowledge** {#s6f14---annotated-event-report-acknowledge}
```
ACKC6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC6 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S6F15 - Event Report Request** {#s6f15---event-report-request}
```
CEID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | U1/U2/U4/A | Collection Event ID |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| RPTID | U1/U2/U4/A | Report ID |
| V | any format | Variable Value |

#### **S6F17 - Annotated Event Report Request** {#s6f17---annotated-event-report-request}
```
CEID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| CEID | U1/U2/U4/A | Collection Event ID |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| CEID | U1/U2/U4/A | Collection Event ID |
| RPTID | U1/U2/U4/A | Report ID |
| VID | U1/U2/U4/A | Variable ID |
| V | any format | Variable Value |

#### **S6F19 - Individual Report Request** {#s6f19---individual-report-request}
```
RPTID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U1/U2/U4/A | Report ID |

#### **S6F20 - Individual Report Data** {#s6f20---individual-report-data}
```
{L[n]
  V
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| V | any format | Variable Value |

#### **S6F21 - Annotated Individual Report Request** {#s6f21---annotated-individual-report-request}
```
RPTID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U1/U2/U4/A | Report ID |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| VID | U1, U2, U4, or A | Variable ID |
| V | any format | Variable Value |

#### **S6F23 - Request or Purge Spooled Data** {#s6f23---request-or-purge-spooled-data}
```
RSDC
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RSDC | A | Request or Purge Spooled Data Command |

#### **S6F24 - Request or Purge Spooled Data Acknowledge** {#s6f24---request-or-purge-spooled-data-acknowledge}
```
RSDA
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RSDA | A | Request or Purge Spooled Data Acknowledge |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| OPID | A | Operator ID |
| LINKID | A | Link ID |
| RCPSPEC | A | Recipe Specification |
| RMCHGSTAT | A | Recipe Change Status |
| RCPATTRID | A | Recipe Attribute ID |
| RCPATTRDATA | any format | Recipe Attribute Data |
| RMACK | B[1] | Recipe Acknowledge |
| ERRCODE | U1 | Error Code |
| ERRTEXT | A | Error Text |

#### **S6F26 - Notification Report Acknowledge** {#s6f26---notification-report-acknowledge}
```
ACKC6
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC6 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| TRID | U1, U2, U4, or A | Trace Request ID |
| RPTID | U1, U2, U4, or A | Report ID |
| V | any format | Variable Value |

#### **S6F28 - Trace Report Acknowledge** {#s6f28---trace-report-acknowledge}
```
TRID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U1, U2, U4, or A | Trace Request ID |

#### **S6F29 - Trace Report Request** {#s6f29---trace-report-request}
```
TRID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U1, U2, U4, or A | Trace Request ID |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U1, U2, U4, or A | Trace Request ID |
| RPTID | U1, U2, U4, or A | Report ID |
| V | any format | Variable Value |
| ERRCODE | A | Error Code |



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
S7F1-> or <-S7F1
{L[2]
  PPID
  LENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | A | Process Program ID |
| LENGTH | U1/U2/U4 | Length of Process Program |

#### **S7F2 - Process Program Load Grant** {#s7f2---process-program-load-grant}
```
S7F2-> or <-S7F2
PPGNT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPGNT | B[1] | Process Program Grant |
| | | 0: Granted |
| | | 1: Busy, try again |
| | | 2: No space |
| | | 3: Invalid PPID |

#### **S7F3 - Process Program Send** {#s7f3---process-program-send}
```
S7F3-> or <-S7F3
{L[2]
  PPID
  PPBODY
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | A | Process Program ID |
| PPBODY | A/B | Process Program Body |

#### **S7F4 - Process Program Send Acknowledge** {#s7f4---process-program-send-acknowledge}
```
S7F4-> or <-S7F4
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F5 - Process Program Request** {#s7f5---process-program-request}
```
S7F5-> or <-S7F5
PPID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |

#### **S7F6 - Process Program Data** {#s7f6---process-program-data}
```
S7F6-> or <-S7F6
{L[2]
  PPID
  PPBODY
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| PPBODY | ASCII/Binary | Process Program Body |

#### **S7F7 - Process Program ID Request** {#s7f7---process-program-id-request}
```
<-S7F7
MID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Material ID |

#### **S7F8 - Process Program ID Data** {#s7f8---process-program-id-data}
```
S7F8->
{L[2]
  PPID
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| MID | ASCII | Material ID |

#### **S7F9 - Material/Process Matrix Request** {#s7f9---material-process-matrix-request}
```
S7F9-> or <-S7F9
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header | - | Header only message |

#### **S7F10 - Material/Process Matrix Data** {#s7f10---material-process-matrix-data}
```
S7F10-> or <-S7F10
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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| MID | ASCII | Material ID |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| MID | ASCII | Material ID |

#### **S7F12 - Material/Process Matrix Update Acknowledge** {#s7f12---material-process-matrix-update-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| MID | ASCII | Material ID |

#### **S7F14 - Delete Material/Process Matrix Entry Acknowledge** {#s7f14---delete-material-process-matrix-entry-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F15 - Matrix Mode Select Send** {#s7f15---matrix-mode-select-send}
```
MMODE
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MMODE | ASCII | Matrix Mode |

#### **S7F16 - Matrix Mode Select Acknowledge** {#s7f16---matrix-mode-select-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F17 - Delete Process Program Send** {#s7f17---delete-process-program-send}
```
<-S7F17
{L[n]
  PPID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |

#### **S7F18 - Delete Process Program Acknowledge** {#s7f18---delete-process-program-acknowledge}
```
S7F18->
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F19 - Current Process Program Directory Request** {#s7f19---current-process-program-directory-request}
```
<-S7F19
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header | - | Header only message |

#### **S7F20 - Current Process Program Data** {#s7f20---current-process-program-data}
```
S7F20->
{L[n]
    PPID
    }
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |

#### **S7F21 - Process Capabilities Request** {#s7f21---process-capabilities-request}
```
<-S7F21
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header | - | Header only message |

#### **S7F22 - Process Capabilities Data** {#s7f22---process-capabilities-data}
```
S7F22->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MDLN | ASCII | Model Number |
| SOFTREV | ASCII | Software Revision |
| CMDMAX | U1/U2/U4 | Command Maximum |
| BYTMAX | U1/U2/U4 | Byte Maximum |
| CCODE | ASCII | Command Code |
| CNAME | ASCII | Command Name |
| RQCMD | ASCII | Required Command |
| BLKDEF | ASCII | Block Definition |
| BCDS | ASCII | Block Code Data Set |
| IBCDS | ASCII | Input Block Code Data Set |
| NBCDS | ASCII | Number Block Code Data Set |
| ACDS | ASCII | Alarm Code Data Set |
| IACDS | ASCII | Input Alarm Code Data Set |
| NACDS | ASCII | Number Alarm Code Data Set |
| L[x] | Various | Variable length data (any format) |

#### **S7F23 - Formatted Process Program Send** {#s7f23---formatted-process-program-send}
```
<-S7F23
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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| MDLN | ASCII | Model Number |
| SOFTREV | ASCII | Software Revision |
| CCODE | ASCII | Command Code |
| PPARM | Various | Process Program Parameter (any format) |

#### **S7F24 - Formatted Process Program Acknowledge** {#s7f24---formatted-process-program-acknowledge}
```
S7F24->
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F25 - Formatted Process Program Request** {#s7f25---formatted-process-program-request}
```
<-S7F25
PPID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |

#### **S7F26 - Formatted Process Program Data** {#s7f26---formatted-process-program-data}
```
S7F26->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| MDLN | ASCII | Model Number |
| SOFTREV | ASCII | Software Revision |
| CCODE | ASCII | Command Code |
| PPARM | Various | Process Program Parameter (any format) |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | ASCII | Process Program ID |
| ACKC7A | B[1] | Acknowledge Code 7A |
| SEQNUM | U1/U2/U4 | Sequence Number |
| ERRW7 | ASCII | Error Word 7 |

#### **S7F28 - Process Program Verification Acknowledge** {#s7f28---process-program-verification-acknowledge}
```
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header | - | Header only message |

#### **S7F29 - Process Program Verification Inquire** {#s7f29---process-program-verification-inquire}
```
LENGTH
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| LENGTH | U4 | Length of S7F27 message |

#### **S7F30 - Process Program Verification Grant** {#s7f30---process-program-verification-grant}
```
PPGNT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPGNT | B[1] | Process Program Grant |
| | | 0: Granted |
| | | 1: Busy, try again |
| | | 2: No space |
| | | 3: Invalid PPID |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | A | Process Program ID |
| MDLN | A | Model Number |
| SOFTREV | A | Software Revision |
| CCODE | A | Command Code |
| PPARM | any format | Process Program Parameter |

#### **S7F32 - Verification Request Acknowledge** {#s7f32---verification-request-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F33 - Process Program Available Request** {#s7f33---process-program-available-request}
```
PPID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | A | Process Program ID |

#### **S7F34 - Process Program Availability Data** {#s7f34---process-program-availability-data}
```
{L[3]
  PPID
  UNFLEN
  FRMLEN
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PPID | A | Process Program ID |
| UNFLEN | U1/U2/U4 | Unformatted Length |
| FRMLEN | U1/U2/U4 | Formatted Length |

#### **S7F35 - Process Program for MID Request** {#s7f35---process-program-for-mid-request}
```
MID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | A | Material ID |

#### **S7F36 - Process Program for MID Data** {#s7f36---process-program-for-mid-data}
```
{L[3]
  MID
  PPID
  PPBODY
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | A | Material ID |
| PPID | A | Process Program ID |
| PPBODY | A/B | Process Program Body |

#### **S7F37 - Large Process Program Send** {#s7f37---large-process-program-send}
```
DSNAME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | A | Data Set Name |

#### **S7F38 - Large Process Program Send Acknowledge** {#s7f38---large-process-program-send-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F39 - Large Formatted Process Program Send** {#s7f39---large-formatted-process-program-send}
```
DSNAME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | A | Data Set Name |

#### **S7F40 - Large Formatted Process Program Acknowledge** {#s7f40---large-formatted-process-program-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F41 - Large Process Program Request** {#s7f41---large-process-program-request}
```
DSNAME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | A | Data Set Name |

#### **S7F42 - Large Process Program Request Acknowledge** {#s7f42---large-process-program-request-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |

#### **S7F43 - Large Formatted Process Program Request** {#s7f43---large-formatted-process-program-request}
```
DSNAME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | A | Data Set Name |

#### **S7F44 - Large Formatted Process Program Request Acknowledge** {#s7f44---large-formatted-process-program-request-acknowledge}
```
ACKC7
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC7 | B[1] | Acknowledge Code |
| | | 0: Accepted |
| | | 1: Permission not granted |
| | | 2: Length error |
| | | 3: Matrix overflow |
| | | 4: PPID not found |
| | | 5: Mode unsupported |
| | | 6: Communication not available |
| | | 7: Busy |


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
<-S8F1
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| - | - | Empty list (header only message) |

#### **S8F2 - Boot Program Data** {#s8f2---boot-program-data}
```
S8F2->
BPD
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| BPD | B | Boot Program Data |

#### **S8F3 - Executive Program Request** {#s8f3---executive-program-request}
```
<-S8F3
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| - | - | Empty list (header only message) |

#### **S8F4 - Executive Program Data** {#s8f4---executive-program-data}
```
S8F4->
EPD
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EPD | B | Executive Program Data |



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

S9F1->
MHEAD

```
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MHEAD | B[10] | Message Header (The complete 10-byte header of the unrecognized message) |
 

#### **S9F3 - Unrecognized Stream Type** {#s9f3---unrecognized-stream-type}
```

S9F3->
MHEAD

```
 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MHEAD | B[10] | Message Header (The complete 10-byte header of the message with unrecognized stream type) |
 

#### **S9F5 - Unrecognized Function Type** {#s9f5---unrecognized-function-type}
```

S9F5->
MHEAD

```
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MHEAD | B[10] | Message Header (The complete 10-byte header of the message with unrecognized function type) |
 


# S9F7 (Error message) Overview

The S9F7 message is an unsolicited message sent by the equipment to notify the host of an error when it cannot process a received message. This message helps diagnose communication errors and enables the host to correct or respond to the issue.

## 1. Scenario Initiation: Host Message Transmission
- The **host** sends a SECS-II message (e.g., S1F1, S2F23) to the equipment.
- The message contains commands or data requests (e.g., status variable requests, data collection setup) that the equipment is expected to process.

## 2. Error Occurrence
- An error occurs while the equipment processes the received message. Common causes for S9F7 errors include:
  - **Invalid Data Format**: The message's data structure does not comply with SEMI standards or contains unexpected values (e.g., incorrect SVID, abnormal data length).
  - **Unknown Stream/Function**: The stream or function sent by the host is not supported by the equipment (e.g., an undefined message like S99F99).
  - **Invalid Transaction ID**: The transaction ID is invalid or does not match the expected response.
  - **Equipment State Mismatch**: The requested operation cannot be performed in the equipment's current state (e.g., requesting a setting change during processing).
  - **Message Length Error**: The message length does not conform to standards or is shorter/longer than expected.

## 3. S9F7 Message Transmission
- Upon detecting the error, the equipment sends an **S9F7** message to the host.
- The S9F7 message includes the following information:
  - **MHEAD**: Header information from the original message (stream/function and transaction ID of the erroneous message).
  - **ERRCODE**: An error code identifying the cause of the error (e.g., 1 = unknown stream, 3 = invalid data).
  - **ERRTEXT**: A human-readable description of the error (string format).
- **Example**: If the host sends an S2F23 message with an invalid SVID, the equipment reports the error via S9F7 with ERRTEXT such as "Invalid SVID."

## 4. Host Response
- The host receives the S9F7 message and analyzes the ERRCODE and ERRTEXT to identify the error cause.
- Response actions:
  - **Message Correction**: Fix invalid data (e.g., SVID, data format) and retransmit the message.
  - **Equipment State Check**: Verify the equipment’s current state (e.g., via S1F1) to ensure the request is appropriate.
  - **Log Recording**: Log the error for debugging or further action.
- **Example**: If S9F7 reports "Invalid SVID," the host verifies the correct SVID and retransmits S2F23.

## 5. Scenario Termination
- Once the host sends a corrected message or resolves the error, normal communication resumes.
- If the error persists, the host may perform additional diagnostics (e.g., request equipment logs, check status variables via S2F13) or request operator intervention.

#### **S9F7 - Illegal Data** {#s9f7---illegal-data}
```

S9F7->
MHEAD

```
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MHEAD | B[10] | Message Header (The complete 10-byte header of the message with illegal data) |
 
#### **S9F9 - Transaction Timer Timeout** {#s9f9---transaction-timer-timeout}
```

S9F9->
MHEAD

```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MHEAD | B[10] | Message Header (The complete 10-byte header of the message that timed out) |
 
#### **S9F11 - Data Too Long** {#s9f11---data-too-long}
```

S9F11->
MHEAD

```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MHEAD | B[10] | Message Header (The complete 10-byte header of the message that was too long) |
 

#### **S9F13 - Conversation Timeout** {#s9f13---conversation-timeout}
```

S9F13->
{L[2]
  MEXP
  EDID
}

```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MEXP | B[1] | Message Expected (Stream and Function of the expected message) |
| EDID | U1/U2/U4/A | Equipment ID (ID of the equipment that timed out) |
 

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

<-S10F1
{L[2]
  TID
  TEXT
}

```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TID | U1 | Terminal ID |
| TEXT | ASCII | Text Message |
 

#### **S10F2 - Terminal Response** {#s10f2---terminal-response}
```
S10F2->
{L[2]
  TID
  ACKC10
}
```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TID | U1 | Terminal ID |
| ACKC10 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Terminal not available |


#### **S10F3 - Terminal Display, Single** {#s10f3---terminal-display-single}
```
S10F3->
{L[2]
  TID
  TEXT
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TID | U1 | Terminal ID |
| TEXT | A | Text Message |


#### **S10F5 - Terminal Display, Multi-Block** {#s10f5---terminal-display-multi-block}
```
S10F5->
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
 **Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TID | U1 | Terminal ID |
| TEXT | ASCII | Text Message |
| MHEAD | B[10] | Message Header |


#### **S10F7 - Multi-block Not Allowed** {#s10f7---multi-block-not-allowed}
```
S10F7->
TID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TID | U1/U2/U4/A | Transaction ID |

#### **S10F9 - Broadcast Display Request** {#s10f9---broadcast-display-request}
```
<-S10F9
TEXT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TEXT | ASCII | Text Message |

#### **S10F10 - Broadcast Display Acknowledge** {#s10f10---broadcast-display-acknowledge}
```
S10F10->
ACKC10
```
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC10 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Broadcast not supported |
 
 

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
<-S12F1
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| FNLOC | ASCII | Final Location |
| FFROT | ASCII | Final Format Rotation |
| ORLOC | ASCII | Origin Location |
| RPSEL | ASCII | Reference Point Select |
| REFP | ASCII | Reference Point |
| DUTMS | ASCII | Die Unit Time Stamp |
| XDIES | U1/U2/U4 | X Dies |
| YDIES | U1/U2/U4 | Y Dies |
| ROWCT | U1/U2/U4 | Row Count |
| COLCT | U1/U2/U4 | Column Count |
| NULBC | U1/U2/U4 | Null Block Count |
| PRDCT | U1/U2/U4 | Production Count |
| PRAXI | ASCII | Production Axis |

#### **S12F2 - Map Setup Data Acknowledge** {#s12f2---map-setup-data-acknowledge}
```
S12F2->
SDACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SDACK | B[1] | Setup Data Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S12F3 - Map Setup Data Request** {#s12f3---map-setup-data-request}
```
<-S12F3
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| MAPFT | ASCII | Map Format |
| FNLOC | ASCII | Final Location |
| FFROT | ASCII | Final Format Rotation |
| ORLOC | ASCII | Origin Location |
| PRAXI | ASCII | Production Axis |
| BCEQU | U1/U2/U4 | Block Count Equal |
| NULBC | U1/U2/U4 | Null Block Count |

#### **S12F4 - Map Setup Data Response** {#s12f4---map-setup-data-response}
```
S12F4->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| FNLOC | ASCII | Final Location |
| ORLOC | ASCII | Origin Location |
| RPSEL | ASCII | Reference Point Select |
| REFP | ASCII | Reference Point |
| DUTMS | ASCII | Die Unit Time Stamp |
| XDIES | U1/U2/U4 | X Dies |
| YDIES | U1/U2/U4 | Y Dies |
| ROWCT | U1/U2/U4 | Row Count |
| COLCT | U1/U2/U4 | Column Count |
| PRDCT | U1/U2/U4 | Production Count |
| BCEQU | U1/U2/U4 | Block Count Equal |
| NULBC | U1/U2/U4 | Null Block Count |
| MLCL | ASCII | Map Location |

#### **S12F5 - Map Transmit Inquire** {#s12f5---map-transmit-inquire}
```
<-S12F5
{L[4]
  MID
  IDTYP
  MAPFT
  MLCL
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| MAPFT | ASCII | Map Format |
| MLCL | ASCII | Map Location |

#### **S12F6 - Map Transmit Grant** {#s12f6---map-transmit-grant}
```
S12F6->
GRNT1
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRNT1 | B[1] | Grant Type 1 |
| | | 0: Granted |
| | | 1: Busy, try again |
| | | 2: No space |

#### **S12F7 - Map Data Send Type 1** {#s12f7---map-data-send-type-1}
```
<-S12F7
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| RSINF | ASCII | Row Information |
| BINLT | Binary | Binary Data |

#### **S12F8 - Map Data Ack Type 1** {#s12f8---map-data-ack-type-1}
```
S12F8->
MDACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MDACK | B[1] | Map Data Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S12F9 - Map Data Send Type 2** {#s12f9---map-data-send-type-2}
```
<-S12F9
{L[4]
  MID
  IDTYP
  STRP
  BINLT
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| STRP | ASCII | Strip Data |
| BINLT | Binary | Binary Data |

#### **S12F10 - Map Data Ack Type 2** {#s12f10---map-data-ack-type-2}
```
S12F10->
MDACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MDACK | B[1] | Map Data Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S12F11 - Map Data Send Type 3** {#s12f11---map-data-send-type-3}
```
<-S12F11
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| XYPOS | ASCII | XY Position |
| BINLT | Binary | Binary Data |

#### **S12F12 - Map Data Ack Type 3** {#s12f12---map-data-ack-type-3}
```
S12F12->
MDACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MDACK | B[1] | Map Data Acknowledge |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S12F13 - Map Data Request Type 1** {#s12f13---map-data-request-type-1}
```
<-S12F13
{L[2]
  MID
  IDTYP
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |

#### **S12F14 - Map Data Type 1** {#s12f14---map-data-type-1}
```
S12F14->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | ASCII | Map ID |
| IDTYP | B[1] | ID Type |
| RSINF | ASCII | Row Information |
| BINLT | Binary | Binary Data |

#### **S12F15 - Map Data Request Type 2** {#s12f15---map-data-request-type-2}
```
<-S12F15
{L[2]
  MID
  IDTYP
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | A | Map ID |
| IDTYP | B[1] | ID Type |

#### **S12F16 - Map Data Type 2** {#s12f16---map-data-type-2}
```
S12F16->
{L[4]
  MID
  IDTYP
  STRP
  BINLT
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | A | Map ID |
| IDTYP | B[1] | ID Type |
| STRP | A | Strip Data |
| BINLT | B | Binary Data |


#### **S12F17 - Map Data Request Type 3** {#s12f17---map-data-request-type-3}
```
<-S12F17
{L[3]
  MID
  IDTYP
  SDBIN
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | A | Map ID |
| IDTYP | B[1] | ID Type |
| SDBIN | B | Sub Data Binary |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| MID | A | Map ID |
| IDTYP | B[1] | ID Type |
| XYPOS | A | XY Position |
| BINLT | B | Binary Data |

#### **S12F19 - Map Error Report Send** {#s12f19---map-error-report-send}
```
{L[2]
  MAPER
  DATLC
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| MAPER | ASCII | Map Error |
| DATLC | ASCII | Data Location |



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

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | ASCII | Data Set Name |
| Comment | - | S13F1 seems to have the L: wrapper that S13F2 is missing. Be prepared to receive DSNAME without the L: |

#### **S13F2 - Send Data Set Ack** {#s13f2---send-data-set-ack}
```
{L[2]
  DSNAME
  ACKC13
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | ASCII | Data Set Name |
| ACKC13 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| Comment | - | The standards have had an erroneous structure for years - the L[2] has been missing. Unfortunately some implementations have not realized it was an error. The latest Hume versions automagically create the L[2] wrapper when it is missing. |

#### **S13F3 - Open Data Set Request** {#s13f3---open-data-set-request}
```
{L[3]
  HANDLE
  DSNAME
  CKPNT
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| HANDLE | ASCII | Handle |
| DSNAME | ASCII | Data Set Name |
| CKPNT | ASCII | Checkpoint |
| Comment | - | Sent by the receiver to open a data set for reading |

#### **S13F4 - Open Data Set Data** {#s13f4---open-data-set-data}
```
S13F4->
{L[5]
  HANDLE
  DSNAME
  ACKC13
  RTYPE
  RECLEN
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| HANDLE | ASCII | Handle |
| DSNAME | ASCII | Data Set Name |
| ACKC13 | B[1] | Acknowledge Code |
| RTYPE | ASCII | Record Type |
| RECLEN | U1/U2/U4 | Record Length |

#### **S13F5 - Read Data Set Request** {#s13f5---read-data-set-request}
```
<-S13F5
{L[2]
  HANDLE
  READLN
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| HANDLE | ASCII | Handle |
| READLN | U1/U2/U4 | Read Length |

#### **S13F6 - Read Data Set Data** {#s13f6---read-data-set-data}
```
S13F6->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| HANDLE | ASCII | Handle |
| ACKC13 | B[1] | Acknowledge Code |
| CKPNT | ASCII | Checkpoint |
| FILDAT | Various | File Data (any format) |

#### **S13F7 - Close Data Set Send** {#s13f7---close-data-set-send}
```
<-S13F7
{L[1]
  HANDLE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| HANDLE | ASCII | Handle |

#### **S13F8 - Close Data Set Ack** {#s13f8---close-data-set-ack}
```
S13F8->
{L[2]
  HANDLE
  ACKC13
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| HANDLE | ASCII | Handle |
| ACKC13 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |

#### **S13F9 - Reset Data Set Send** {#s13f9---reset-data-set-send}
```
<-S13F9
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header | - | Empty list (header only message) |

#### **S13F10 - Reset Data Set Ack** {#s13f10---reset-data-set-ack}
```
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Header | - | Empty list (header only message) |

#### **S13F11 - Data Set Obj Multi-Block Inquire** {#s13f11---data-set-obj-multi-block-inquire}
```
{L[3]
  DATAID
  OBJSPEC
  DATALENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| OBJSPEC | ASCII | Object Specification |
| DATALENGTH | U1/U2/U4 | Data Length |

#### **S13F12 - Data Set Obj Multi-Block Grant** {#s13f12---data-set-obj-multi-block-grant}
```
GRANT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | B[1] | Grant signal |
| | | 0: Not granted |
| | | 1: Granted |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| OBJSPEC | ASCII | Object Specification |
| TBLTYP | ASCII | Table Type |
| TBLID | ASCII | Table ID |
| TBLCMD | ASCII | Table Command |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| COLHDR | ASCII | Column Header |
| TBLELT | Various | Table Element (any format) |
| Comment | - | The first element of every row is a primary key value which identifies the row. The row items correspond in sequence to the column headers. E58 uses attributes NumCols, NumRows, and DataLength |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| TBLACK | B[1] | Table Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| OBJSPEC | ASCII | Object Specification |
| TBLTYP | ASCII | Table Type |
| TBLID | ASCII | Table ID |
| TBLCMD | ASCII | Table Command |
| COLHDR | ASCII | Column Header |
| TBLELT | Various | Table Element (any format) |
| Comment | - | Either p or q or both are 0. |

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

| Parameter | Type | Description |
|-----------|------|-------------|
| TBLTYP | ASCII | Table Type |
| TBLID | ASCII | Table ID |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| COLHDR | ASCII | Column Header |
| TBLELT | Various | Table Element (any format) |
| TBLACK | B[1] | Table Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |


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
<-S14F1
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| OBJTYPE | ASCII | Object Type |
| OBJID | ASCII | Object ID |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| ATTRRELN | ASCII | Attribute Relation |
| Comment | - | List lengths can be 0, and OBJSPEC can be zero-length. |

#### **S14F2 - Attribute Data** {#s14f2---attribute-data}
```
S14F2->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F3 - Set Attributes** {#s14f3---set-attributes}
```
<-S14F3
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| OBJTYPE | ASCII | Object Type |
| OBJID | ASCII | Object ID |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |


#### **S14F4 - Set Attributes Reply** {#s14f4---set-attributes-reply}
```
S14F4->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F5 - Get Type Data** {#s14f5---get-type-data}
```
<-S14F5
OBJSPEC
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| Comment | - | Asks for the types of objects owned by the type of specified object |

#### **S14F6 - Type Data** {#s14f6---type-data}
```
S14F6->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJTYPE | ASCII | Object Type |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F7 - Get Attribute Names** {#s14f7---get-attribute-names}
```
<-S14F7
{L[2]
  OBJSPEC
  {L[n]
    OBJTYPE
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| OBJTYPE | ASCII | Object Type |

#### **S14F8 - Attribute Names** {#s14f8---attribute-names}
```
S14F8->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJTYPE | ASCII | Object Type |
| ATTRID | ASCII | Attribute ID |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F9 - Create Object Request** {#s14f9---create-obj-request}
```
<-S14F9
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| OBJTYPE | ASCII | Object Type |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |

#### **S14F10 - Create Object Acknowledge** {#s14f10---create-obj-ack}
```
S14F10->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F11 - Delete Object Request** {#s14f11---delete-obj-request}
```
<-S14F11
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |

#### **S14F12 - Delete Object Acknowledge** {#s14f12---delete-obj-ack}
```
S14F12->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F13 - Object Attach Request** {#s14f13---object-attach-request}
```
<-S14F13
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| ATTRID | ASCII | Attribute ID |
| ATTRDATA | Various | Attribute Data (any format) |


#### **S14F14 - Object Attach Acknowledge** {#s14f14---object-attach-ack}
```
S14F14->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJTOKEN | A | Object Token |
| ATTRID | A | Attribute ID |
| ATTRDATA | any format | Attribute Data |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1, U2, U4, or A | Error Code |
| ERRTEXT | A | Error Text |

#### **S14F15 - Attached Object Action Request** {#s14f15---attached-obj-action-req}
```
<-S14F15
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | A | Object Specification |
| OBJCMD | A | Object Command |
| OBJTOKEN | A | Object Token |
| ATTRID | A | Attribute ID |
| ATTRDATA | any format | Attribute Data |

#### **S14F16 - Attached Object Action Acknowledge** {#s14f16---attached-obj-action-ack}
```
S14F16->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| ATTRID | A | Attribute ID |
| ATTRDATA | any format | Attribute Data |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1, U2, U4, or A | Error Code |
| ERRTEXT | A | Error Text |

#### **S14F17 - Supervised Object Action Request** {#s14f17---supervised-obj-action-req}
```
<-S14F17
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | A | Object Specification |
| OBJCMD | A | Object Command |
| TARGETSPEC | A | Target Specification |
| ATTRID | A | Attribute ID |
| ATTRDATA | any format | Attribute Data |

#### **S14F18 - Supervised Object Action Acknowledge** {#s14f18---supervised-obj-action-ack}
```
S14F18->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| ATTRID | A | Attribute ID |
| ATTRDATA | any format | Attribute Data |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1, U2, U4, or A | Error Code |
| ERRTEXT | A | Error Text |

#### **S14F19 - Generic Service Request** {#s14f19---generic-service-req}
```
<-S14F19
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| OPID | A | Operation ID |
| OBJSPEC | A | Object Specification |
| SVCNAME | A | Service Name |
| SPNAME | A | Service Parameter Name |
| SPVAL | any format | Service Parameter Value |

#### **S14F20 - Generic Service Acknowledge** {#s14f20---generic-service-ack}
```
S14F20->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| SVCACK | B[1] | Service Acknowledge |
| LINKID | A | Link ID |
| SPNAME | A | Service Parameter Name |
| SPVAL | any format | Service Parameter Value |
| ERRCODE | U1, U2, U4, or A | Error Code |
| ERRTEXT | A | Error Text |
| | | Comment: It is not a mistake that SVCACK is included twice |

#### **S14F21 - Generic Service Completion** {#s14f21---generic-service-completion}
```
S14F21->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| OPID | A | Operation ID |
| LINKID | A | Link ID |
| SPNAME | A | Service Parameter Name |
| SPVAL | any format | Service Parameter Value |
| SVCACK | B[1] | Service Acknowledge |
| ERRCODE | U1, U2, U4, or A | Error Code |
| ERRTEXT | A | Error Text |

#### **S14F22 - Generic Service Completion Acknowledge** {#s14f22---generic-service-comp-ack}
```
<-S14F22
DATAACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAACK | B[1] | Data Acknowledge |

#### **S14F23 - Multi-block Generic Service Inquire** {#s14f23---multi-block-generic-service-inquire}
```
<-S14F23
{L[2]
  DATAID
  DATALENGTH
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1, U2, U4, or A | Data ID |
| DATALENGTH | U1, U2, U4 | Data Length |
| | | Comment: You are advised not to implement this message |

#### **S14F24 - Multi-block Generic Service Grant** {#s14f24---multi-block-generic-service-grant}
```
S14F24->
GRANT
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | B[1] | Grant signal (0: Not granted, 1: Granted) |

#### **S14F25 - Service Name Request** {#s14f25---service-name-request}
```
<-S14F25
{L[2]
  OBJSPEC
  {L[n]
    OBJTYPE
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| OBJTYPE | ASCII | Object Type |

#### **S14F26 - Service Name Data** {#s14f26---service-name-data}
```
S14F26->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJTYPE | ASCII | Object Type |
| SVCNAME | ASCII | Service Name |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |

#### **S14F27 - Service Parameter Name Request** {#s14f27---service-parameter-name-req}
```
<-S14F27
{L[3]
  OBJSPEC
  OBJTYPE
  {L[n]
    SVCNAME
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object Specification |
| OBJTYPE | ASCII | Object Type |
| SVCNAME | ASCII | Service Name |

#### **S14F28 - Service Parameter Name Data** {#s14f28---service-parameter-name-data}
```
S14F28->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| SVCNAME | ASCII | Service Name |
| SPNAME | ASCII | Service Parameter Name |
| OBJACK | B[1] | Object Acknowledge |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |



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


```
S15F1-> or <-S15F1
{L[3]
  DATAID
  RCPSPEC
  RMDATASIZE
}
```

#### **S15F2 - Recipe Management Multi-block Grant** {#s15f2---recipe-management-multi-block-grant}

```
S15F2-> or <-S15F2
  RMGRNT
```

#### **S15F3 - Recipe Namespace Action Req** {#s15f3---recipe-namespace-action-req}

```
S15F3-> or <-S15F3
{L[2]
  RMNSSPEC
  RMNSCMD
}
```

#### **S15F4 - Recipe Namespace Action** {#s15f4---recipe-namespace-action}

```
S15F4-> or <-S15F4
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

#### **S15F5 - Recipe Namespace Rename Req** {#s15f5---recipe-namespace-rename-req}

```
S15F5-> or <-S15F5
{L[2]
  RMNSSPEC
  RMNEWNS
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMNSSPEC | ASCII | Recipe namespace specification |
| RMNEWNS | ASCII | New namespace name |

#### **S15F6 - Recipe Namespace Rename Ack** {#s15f6---recipe-namespace-rename-ack}

```
S15F6-> or <-S15F6
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | U1 | Recipe management acknowledge code |
| ERRCODE | U1 | Error code |
| ERRTEXT | ASCII | Error text description |

#### **S15F7 - Recipe Space Req** {#s15f7---recipe-space-req}

```
S15F7-> or <-S15F7
OBJSPEC
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJSPEC | ASCII | Object specification for recipe space |

#### **S15F8 - Recipe Space Data** {#s15f8---recipe-space-data}

```
S15F8-> or <-S15F8
{L[2]
  RMSPACE
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RMSPACE | U4 | Recipe space information |
| RMACK | U1 | Recipe management acknowledge code |
| ERRCODE | U1 | Error code |
| ERRTEXT | ASCII | Error text description |

#### **S15F9 - Recipe Status Request** {#s15f9---recipe-status-request}

```
S15F9-> or <-S15F9
RCPSPEC
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RCPSPEC | ASCII | Recipe specification |

#### **S15F10 - Recipe Status Data** {#s15f10---recipe-status-data}

```
S15F10-> or <-S15F10
{L[3]
  RCPSTAT
  RCPVERS
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RCPSTAT | U1 | Recipe status |
| RCPVERS | ASCII | Recipe version |
| RMACK | U1 | Recipe management acknowledge code |
| ERRCODE | U1 | Error code |
| ERRTEXT | ASCII | Error text description |

#### **S15F11 - Recipe Version Request** {#s15f11---recipe-version-request}

```
S15F11-> or <-S15F11
{L[4]
  RMNSSPEC
  RCPCLASS
  RCPNAME
  AGENT
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMNSSPEC | ASCII | Recipe namespace specification |
| RCPCLASS | ASCII | Recipe class |
| RCPNAME | ASCII | Recipe name |
| AGENT | ASCII | Agent identifier |

#### **S15F12 - Recipe Version Data** {#s15f12---recipe-version-data}

```
S15F12-> or <-S15F12
{L[3]
  AGENT
  RCPVERS
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

#### **S15F13 - Recipe Create Req** {#s15f13---recipe-create-req}

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

```
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

#### **S15F15 - Recipe Store Req** {#s15f15---recipe-store-req}
**Comment**: L[2]* can be L[2] or L:0; E5 documentation is inadequate for L[n] other than L[3]


```
{L[4]
  DATAID
  RCPSPEC
  RCPSECCODE
  {L[3]
    {L[2]*
      RCPSECNM
        {L[o]
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

```
{L[2]
  RCPSECCODE
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

#### **S15F17 - Recipe Retrieve Req** {#s15f17---recipe-retrieve-req}

```
{L[2]
  RCPSPEC
  RCPSECCODE
}
```

#### **S15F18 - Recipe Retrieve Data** {#s15f18---recipe-retrieve-data}

```
{L[2]
  {L[n]
    {L[n]
      RCPSECNM
      {L[n]
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
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

#### **S15F19 - Recipe Rename Req** {#s15f19---recipe-rename-req}

```
{L[3]
  RCPSPEC
  RCPRENAME
  RCPNEWID
}
```

#### **S15F20 - Recipe Rename Ack** {#s15f20---recipe-rename-ack}

```
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

#### **S15F21 - Recipe Action Req** {#s15f21---recipe-action-req}

```
{L[6]
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

```
{L[4]
  AGENT
  LINKID
  RCPCMD
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

#### **S15F23 - Recipe Descriptor Req** {#s15f23---recipe-descriptor-req}

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
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

#### **S15F25 - Recipe Parameter Update Req** {#s15f25---recipe-parameter-update-req}

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

```
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

#### **S15F27 - Recipe Download Req** {#s15f27---recipe-download-req}

```
<-S15F27
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

```
S15F28->
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
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

#### **S15F29 - Recipe Verify Req** {#s15f29---recipe-verify-req}

```
<-S15F29
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

```
S15F30->
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
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

#### **S15F31 - Recipe Unload Req** {#s15f31---recipe-unload-req}

```
<-S15F31
RCPSPEC
```

#### **S15F32 - Recipe Unload Data** {#s15f32---recipe-unload-data}

```
S15F32->
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
    {L[p]
      {L[2]
        ERRCODE
        ERRTEXT
      }
    }
  }
}
```

#### **S15F33 - Recipe Select Req** {#s15f33---recipe-select-req}

```
<-S15F33
{L[3]
  DATAID
  RESPEC
  {L[m]
    {L[2]
      RCPID
      {L[p]
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
S15F34->
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F35 - Recipe Delete Request** {#s15f35---recipe-delete-req}
```
<-S15F35
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| RESPEC | A | Recipe Specification |
| RCPDEL | B[1] | Recipe Delete<br>0: Delete<br>1: Keep |
| RCPID | A | Recipe ID |


#### **S15F36 - Recipe Delete Acknowledge** {#s15f36---recipe-delete-ack}
```
S15F36->
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F37 - DRNS Segment Approve Action Request** {#s15f37---drns-segment-approve-action-req}
```
S15F37-> or <-S15F37
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RMSEGSPEC | A | Recipe Management Segment Specification |
| OBJTOKEN | A | Object Token |
| RMGRNT | B[1] | Recipe Management Grant<br>0: Granted<br>1: Not granted |
| OPID | A | Operation ID |
| RCPID | A | Recipe ID |
| RMCHGTYPE | A | Recipe Management Change Type |


#### **S15F38 - DRNS Segment Approve Action Acknowledge** {#s15f38---drns-segment-approve-action-ack}
```
S15F38-> or <-S15F38
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F39 - DRNS Recorder Segment Request** {#s15f39---drns-recorder-seg-req}
```
S15F39-> or <-S15F39
{L[5]
  DATAID
  RMNSCMD
  RMRECSPEC
  RMSEGSPEC
  OBJTOKEN
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| RMNSCMD | A | Recipe Management Namespace Command |
| RMRECSPEC | A | Recipe Management Recorder Specification |
| RMSEGSPEC | A | Recipe Management Segment Specification |
| OBJTOKEN | A | Object Token |


#### **S15F40 - DRNS Recorder Segment Acknowledge** {#s15f40---drns-recorder-seg-ack}
```
S15F40-> or <-S15F40
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F41 - DRNS Recorder Module Request** {#s15f41---drns-recorder-mod-req}
```
S15F41-> or <-S15F41
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| RMRECSPEC | A | Recipe Management Recorder Specification |
| OBJTOKEN | A | Object Token |
| RMNSCMD | A | Recipe Management Namespace Command |
| RCPID | A | Recipe ID |
| RCPNEWID | A | Recipe New ID |
| RMSEGSPEC | A | Recipe Management Segment Specification |
| RMCHGTYPE | A | Recipe Management Change Type |
| OPID | A | Operation ID |
| TIMESTAMP | A | Time Stamp |
| RMREQUESTOR | A | Recipe Management Requestor |


#### **S15F42 - DRNS Recorder Module Acknowledge** {#s15f42---drns-recorder-mod-ack}
```
S15F42-> or <-S15F42
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F43 - DRNS Get Change Request** {#s15f43---drns-get-change-req}
```
S15F43-> or <-S15F43
{L[3]
  DATAID
  OBJSPEC
  TARGETSPEC
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| OBJSPEC | A | Object Specification |
| TARGETSPEC | A | Target Specification |


#### **S15F44 - DRNS Get Change Acknowledge** {#s15f44---drns-get-change-ack}
```
S15F44-> or <-S15F44
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RCPID | A | Recipe ID |
| RCPNEWID | A | Recipe New ID |
| RMSEGSPEC | A | Recipe Management Segment Specification |
| RMCHGTYPE | A | Recipe Management Change Type |
| OPID | A | Operation ID |
| TIMESTAMP | A | Time Stamp |
| RMREQUESTOR | A | Recipe Management Requestor |
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F45 - DRNS Manager Segment Approval Request** {#s15f45---drns-mgr-seg-aprvl-req}
```
S15F45-> or <-S15F45
{L[4]
  DATAID
  RCPSPEC
  RCPNEWID
  RMCHGTYPE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| RCPSPEC | A | Recipe Specification |
| RCPNEWID | A | Recipe New ID |
| RMCHGTYPE | A | Recipe Management Change Type |


#### **S15F46 - DRNS Manager Segment Approval Acknowledge** {#s15f46---drns-mgr-seg-aprvl-ack}
```
S15F46-> or <-S15F46
{L[3]
  RMCHGTYPE
  RMGRNT
  OPID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMCHGTYPE | A | Recipe Management Change Type |
| RMGRNT | B[1] | Recipe Management Grant<br>0: Granted<br>1: Not granted |
| OPID | A | Operation ID |


#### **S15F47 - DRNS Manager Rebuild Request** {#s15f47---drns-mgr-rebuild-req}
```
S15F47-> or <-S15F47
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

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| OBJSPEC | A | Object Specification |
| RMNSSPEC | A | Recipe Management Namespace Specification |
| RMRECSPEC | A | Recipe Management Recorder Specification |
| RMSEGSPEC | A | Recipe Management Segment Specification |


#### **S15F48 - DRNS Manager Rebuild Acknowledge** {#s15f48---drns-mgr-rebuild-ack}
```
S15F48-> or <-S15F48
{L[2]
  RMACK
  {L[p]
    {L[2]
      ERRCODE
      ERRTEXT
    }
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F49 - Large Recipe Download Request** {#s15f49---large-recipe-download-req}
```
S15F49-> or <-S15F49
{L[2]
  DSNAME
  RCPOWCODE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | A | Data Set Name - The RCPSPEC for Stream 13 transfer |
| RCPOWCODE | A | Recipe Owner Code |


#### **S15F50 - Large Recipe Download Acknowledge** {#s15f50---large-recipe-download-ack}
```
S15F50-> or <-S15F50
ACKC15
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC15 | B[1] | Acknowledge Code<br>0: Acknowledged<br>1: Error |


#### **S15F51 - Large Recipe Upload Request** {#s15f51---large-recipe-upload-req}
```
S15F51-> or <-S15F51
DSNAME
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DSNAME | A | Data Set Name - The RCPSPEC used in Stream 13 |


#### **S15F52 - Large Recipe Upload Acknowledge** {#s15f52---large-recipe-upload-ack}
```
S15F52-> or <-S15F52
ACKC15
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKC15 | B[1] | Acknowledge Code<br>0: Acknowledged<br>1: Error |


#### **S15F53 - Recipe Verification Send** {#s15f53---recipe-verification-send}
```
S15F53->
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

| Parameter | Type | Description |
|-----------|------|-------------|
| RCPSPEC | A | Recipe Specification |
| RCPID | A | Recipe ID |
| RMACK | B[1] | Recipe Management Acknowledge<br>0: Acknowledged<br>1: Error |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | A | Error Text |


#### **S15F54 - Recipe Verification Acknowledge** {#s15f54---recipe-verification-ack}
```
<-S15F54
{}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| - | - | Empty message (header only) |




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

<-S16F1
{L[2]
  DATAID
  DATALENGTH
}

``` 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| DATALENGTH | U1/U2/U4 | Data Length |
 
 

#### **S16F2 - PJD MBI Grant** {#s16f2---pjd-mbi-grant}
```

S16F2->
GRANT

``` 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| GRANT | B[1] | Grant Code (0: Granted, 1: Busy, try again, 2: No space) |
 

#### **S16F3 - Process Job Create Req** {#s16f3---process-job-create-req}
```

<-S16F3
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| MF | U1 | Material Format |
| MID | ASCII | Material ID |
| PRRECIPEMETHOD | ASCII | Process Recipe Method |
| RCPSPEC | ASCII | Recipe Specification |
| RCPPARNM | ASCII | Recipe Parameter Name |
| RCPPARVAL | Any | Recipe Parameter Value |
| PRPROCESSSTART | ASCII | Process Process Start |
 

#### **S16F4 - Process Job Create Ack** {#s16f4---process-job-create-ack}
```

S16F4->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PRJOBID | ASCII | Process Job ID |
| ACKA | B[1] | Acknowledge Code (0: Acknowledged, 1: Error) |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |
 
#### **S16F5 - Process Job Cmd Req** {#s16f5---process-job-cmd-req}
```

<-S16F5
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U1/U2/U4/A | Data ID |
| PRJOBID | ASCII | Process Job ID |
| PRCMDNAME | ASCII | Process Command Name |
| CPNAME | ASCII | Command Parameter Name |
| CPVAL | Any | Command Parameter Value |
 

#### **S16F6 - Process Job Cmd Ack** {#s16f6---process-job-cmd-ack}
```

S16F6->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PRJOBID | ASCII | Process Job ID |
| ACKA | B[1] | Acknowledge Code (0: Acknowledged, 1: Error) |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |
 

#### **S16F7 - Process Job Alert Notify** {#s16f7---process-job-alert-notify}
```

S16F7->
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
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIMESTAMP | ASCII | Timestamp |
| PRJOBID | ASCII | Process Job ID |
| PRJOBMILESTONE | ASCII | Process Job Milestone |
| ACKA | B[1] | Acknowledge Code (0: Acknowledged, 1: Error) |
| ERRCODE | U1/U2/U4/A | Error Code |
| ERRTEXT | ASCII | Error Text |


#### **S16F8 - Process Job Alert Ack** {#s16f8---process-job-alert-ack}
```
{}
``` 

#### **S16F9 - Process Job Event Notify** {#s16f9---process-job-event-notify}
 

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

 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PREVENTID | A | Process Event ID |
| TIMESTAMP | A | Timestamp |
| PRJOBID | A | Process Job ID |
| VID | U1/U2/U4/A | Variable ID |
| V | any format | Variable Value |
 

#### **S16F10 - Process Job Event Ack** {#s16f10---process-job-event-ack}
```
{}

```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| - | - | No parameters required |

#### **S16F11 - Recipe Upload Send** {#s16f11---recipe-upload-send}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

#### **S16F12 - Recipe Upload Acknowledge** {#s16f12---recipe-upload-acknowledge}
```
{L[2]
  EQUIPMENTID
  ACKC16
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| ACKC16 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Invalid recipe type |
| | | 3: Equipment not found |

#### **S16F13 - Recipe Download Request** {#s16f13---recipe-download-request}
```
{L[2]
  EQUIPMENTID
  RECIPETYPE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |

#### **S16F14 - Recipe Download Response** {#s16f14---recipe-download-response}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

#### **S16F15 - Recipe Download Send** {#s16f15---recipe-download-send}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

#### **S16F16 - Recipe Download Acknowledge** {#s16f16---recipe-download-acknowledge}
```
{L[2]
  EQUIPMENTID
  ACKC16
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| ACKC16 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Invalid recipe type |
| | | 3: Equipment not found |

#### **S16F17 - Recipe Validate Request** {#s16f17---recipe-validate-request}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| VALRESULT | B[1] | Validation Result |
| | | 0: Valid |
| | | 1: Invalid |
| ERROR | A | Validation Error |

#### **S16F19 - Recipe Validate Send** {#s16f19---recipe-validate-send}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

#### **S16F20 - Recipe Validate Acknowledge** {#s16f20---recipe-validate-acknowledge}
```
{L[2]
  EQUIPMENTID
  ACKC16
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| ACKC16 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Invalid recipe type |
| | | 3: Equipment not found |

#### **S16F21 - Recipe Compress Request** {#s16f21---recipe-compress-request}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

#### **S16F22 - Recipe Compress Response** {#s16f22---recipe-compress-response}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  COMPRESSEDDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| COMPRESSEDDATA | B | Compressed Data |

#### **S16F23 - Recipe Compress Send** {#s16f23---recipe-compress-send}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  COMPRESSEDDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| COMPRESSEDDATA | B | Compressed Data |

#### **S16F24 - Recipe Compress Acknowledge** {#s16f24---recipe-compress-acknowledge}
```
{L[2]
  EQUIPMENTID
  ACKC16
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| ACKC16 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Invalid recipe type |
| | | 3: Equipment not found |

#### **S16F25 - Recipe Encrypt Request** {#s16f25---recipe-encrypt-request}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  RECIPEDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| RECIPEDATA | any format | Recipe Data |

#### **S16F26 - Recipe Encrypt Response** {#s16f26---recipe-encrypt-response}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  ENCRYPTEDDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| ENCRYPTEDDATA | B | Encrypted Data |

#### **S16F27 - Recipe Encrypt Send** {#s16f27---recipe-encrypt-send}
```
{L[3]
  EQUIPMENTID
  RECIPETYPE
  ENCRYPTEDDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| RECIPETYPE | U1 | Recipe Type |
| ENCRYPTEDDATA | B | Encrypted Data |

#### **S16F28 - Recipe Encrypt Acknowledge** {#s16f28---recipe-encrypt-acknowledge}
```
{L[2]
  EQUIPMENTID
  ACKC16
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EQUIPMENTID | A | Equipment ID |
| ACKC16 | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Invalid recipe type |
| | | 3: Equipment not found |

#### **S16F29 - PRSetMtrlOrder** {#s16f29---prsetmtrlorder}
```
PRMTRLORDER
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PRMTRLORDER | U2 | Process Material Order |

#### **S16F30 - PRSetMtrlOrder Ack** {#s16f30---prsetmtrlorder-ack}
```
ACKA
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKA | B[1] | Acknowledge Code |
| | | 0: Acknowledged |
| | | 1: Error |
| | | 2: Invalid material order |
| | | 3: Process not found |

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
<-S17F1
{L[4]
  DATAID
  RPTID
  DATASRC
  {L[n]
    VID
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U4 | Data ID |
| RPTID | U4 | Report ID |
| DATASRC | A | Data Source |
| VID | U4 | Variable ID |

#### **S17F2 - Data Report Create Acknowledgment** {#s17f2---data-report-create-acknowledgment}
```
S17F2->
{L[2]
  RPTID
  ERRCODE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U4 | Report ID |
| ERRCODE | U4 | Error Code |

#### **S17F3 - Data Report Delete Request** {#s17f3---data-report-delete-request}
```
<-S17F3
{L[n]
  RPTID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| RPTID | U4 | Report ID |
| | | L:0 means delete all reports |

#### **S17F4 - Data Report Delete Acknowledgment** {#s17f4---data-report-delete-acknowledgment}
```
S17F4->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKA | U4 | Acknowledge Code |
| RPTID | U4 | Report ID |
| ERRCODE | U4 | Error Code |
| ERRTEXT | A | Error Text |

#### **S17F5 - Trace Create Request** {#s17f5---trace-create-request}
```
<-S17F5
{L[6]
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U4 | Data ID |
| TRID | U4 | Trace ID |
| CEED | B[1] | Collection Event Enable/Disable |
| RPTID | U4 | Report ID |
| TOTSMP | U4 | Total Samples |
| REPGSZ | U4 | Report Group Size |
| EVNTSRC | A | Event Source |
| CEIDSTART | U4 | Collection Event ID Start |
| EVNTSRC2 | A | Event Source 2 |
| CEIDSTOP | U4 | Collection Event ID Stop |
| TRAUTOD | B[1] | Trace Auto Delete |
| RPTOC | B[1] | Report On Change |
| | | We recommend the host always provides the L:8 values |

#### **S17F6 - Trace Create Acknowledgment** {#s17f6---trace-create-acknowledgment}
```
S17F6->
{L[2]
  TRID
  ERRCODE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U4 | Trace ID |
| ERRCODE | U4 | Error Code |

#### **S17F7 - Trace Delete Request** {#s17f7---trace-delete-request}
```

<-S17F7
{L[n]
  TRID
}

``` 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U4 | Trace ID |

**Note**: Surprisingly, L:0 is not specified as a means to indicate all, but this feature has to be provided because there is no means to discover the existing traces.
 

#### **S17F8 - Trace Delete Acknowledgment** {#s17f8---trace-delete-acknowledgment}
```

S17F8->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKA | U4 | Acknowledge Code |
| TRID | U4 | Trace ID |
| ERRCODE | U4 | Error Code |
| ERRTEXT | ASCII | Error Text |
 
#### **S17F9 - Collection Event Link Request** {#s17f9---collection-event-link-request}
```

<-S17F9
{L[4]
  DATAID
  EVNTSRC
  CEID
  {L[n]
    RPTID
  }
}

```  

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| DATAID | U4 | Data ID |
| EVNTSRC | ASCII | Event Source |
| CEID | U4 | Collection Event ID |
| RPTID | U4 | Report ID |
 
#### **S17F10 - Collection Event Link Acknowledgment** {#s17f10---collection-event-link-acknowledgment}
```

{L[3]
  EVNTSRC
  CEID
  ERRCODE
}

``` 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EVNTSRC | ASCII | Event Source |
| CEID | U4 | Collection Event ID |
| ERRCODE | U4 | Error Code |
 

#### **S17F11 - Collection Event Unlink Request** {#s17f11---collection-event-unlink-request}
```

{L[3]
  EVNTSRC
  CEID
  RPTID
}

``` 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EVNTSRC | ASCII | Event Source |
| CEID | U4 | Collection Event ID |
| RPTID | U4 | Report ID |
 
#### **S17F12 - Collection Event Unlink Acknowledgment** {#s17f12---collection-event-unlink-acknowledgment}
```

{L[4]
  EVNTSRC
  CEID
  RPTID
  ERRCODE
}

``` 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| EVNTSRC | ASCII | Event Source |
| CEID | U4 | Collection Event ID |
| RPTID | U4 | Report ID |
| ERRCODE | U4 | Error Code |
 
#### **S17F13 - Trace Reset Request** {#s17f13---trace-reset-request}
```

{L[n]
TRID
}

```
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TRID | U4 | Trace ID |
 
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
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ACKA | U4 | Acknowledge Code |
| TRID | U4 | Trace ID |
| ERRCODE | U4 | Error Code |
| ERRTEXT | ASCII | Error Text |
 

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

<-S18F1
{L[2]
  TARGETID
  {L[n]
    ATTRID
  }
}

```
 

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | ASCII | Target ID |
| ATTRID | ASCII | Attribute ID |
 

#### **S18F2 - Read Attribute Data** {#s18f2---read-attribute-data}
```

S18F2->
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
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| ATTRDATA | any format | Attribute Data |
| STATUS | A | Status |
| | | Comment: E5 differs from OEM tools |

#### **S18F3 - Write Attribute Request** {#s18f3---write-attribute-request}
```

<-S18F3
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
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| ATTRID | A | Attribute ID |
| ATTRDATA | any format | Attribute Data |

#### **S18F4 - Write Attribute Acknowledgment** {#s18f4---write-attribute-acknowledgment}
```

S18F4->
{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}

```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| STATUS | A | Status |
| | | Comment: Fixed E5 mistake |

#### **S18F5 - Read Request** {#s18f5---read-request}
```

<-S18F5
{L[3]
  TARGETID
  DATASEG
  DATALENGTH
}

```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| DATASEG | A | Data Segment |
| DATALENGTH | U4 | Data Length |

#### **S18F6 - Read Data** {#s18f6---read-data}
```

S18F6->
{L[4]
  TARGETID
  SSACK
  DATA
  {L[n]
    STATUS
  }
}

```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| DATA | any format | Data |
| STATUS | A | Status |

#### **S18F7 - Write Data Request** {#s18f7---write-data-request}
```

<-S18F7
{L[4]
  TARGETID
  DATASEG
  DATALENGTH
  DATA
}

```
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| DATASEG | A | Data Segment |
| DATALENGTH | U4 | Data Length |
| DATA | any format | Data |

#### **S18F8 - Write Data Acknowledgment** {#s18f8---write-data-acknowledgment}
```

S18F8->
{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}

```
 
**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| STATUS | A | Status |
 

#### **S18F9 - Read ID Request** {#s18f9---read-id-request}
```

<-S18F9
TARGETID

```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
 

#### **S18F10 - Read ID Data** {#s18f10---read-id-data}
```
S18F10->
{L[4]
  TARGETID
  SSACK
  MID
  {L[n]
    STATUS
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| MID | A | Module ID |
| STATUS | A | Status |
 

#### **S18F11 - Write ID Request** {#s18f11---write-id-request}
```
<-S18F11
{L[2]
  TARGETID
  MID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| MID | A | Module ID |
 

#### **S18F12 - Write ID Acknowledgment** {#s18f12---write-id-acknowledgment}
```
S18F12->
{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| STATUS | A | Status |
 

#### **S18F13 - Subsystem Command** {#s18f13---subsystem-command}
```
<-S18F13
{L[3]
  TARGETID
  SSCMD
  {L[n]
    CPVAL
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSCMD | A | Subsystem Command |
| CPVAL | any format | Command Parameter Value |
 

#### **S18F14 - Subsystem Command Acknowledgment** {#s18f14---subsystem-command-acknowledgment}
```
S18F14->
{L[3]
  TARGETID
  SSACK
  {L[n]
    STATUS
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| STATUS | A | Status |
 

#### **S18F15 - Read 2D Code Condition Request** {#s18f15---read-2d-code-condition-request}
```
<-S18F15
TARGETID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |


#### **S18F16 - Read 2D Code Condition Data** {#s18f16---read-2d-code-condition-data}
```
S18F16->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TARGETID | A | Target ID |
| SSACK | U4 | Subsystem Acknowledge |
| MID | A | Module ID |
| STATUS | A | Status |
| CONDITION | A | Condition |
 
 
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
<-S19F1
{L[n]
  INVTYPE_1
  INVTYPE_2
  ...
  INVTYPE_n
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVTYPE | ASCII | Inventory Type |

#### **S19F2 - Inventory Response** {#s19f2---inventory-response}
```
S19F2->
{L[n]
  {L[3]
    INVTYPE
    INVID
    INVDATA
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVTYPE | ASCII | Inventory Type |
| INVID | ASCII | Inventory ID |
| INVDATA | Any | Inventory Data |

#### **S19F3 - Inventory Update** {#s19f3---inventory-update}
```
<-S19F3
{L[3]
  INVTYPE
  INVID
  INVDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVTYPE | ASCII | Inventory Type |
| INVID | ASCII | Inventory ID |
| INVDATA | Any | Inventory Data |

#### **S19F4 - Inventory Update Response** {#s19f4---inventory-update-response}
```
S19F4->
{L[2]
  INVID
  ACKC19
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| ACKC19 | U1 | Acknowledge Code |

#### **S19F5 - Inventory Add Request** {#s19f5---inventory-add-request}
```
<-S19F5
{L[4]
  INVTYPE
  INVID
  INVDATA
  LOCATION
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVTYPE | ASCII | Inventory Type |
| INVID | ASCII | Inventory ID |
| INVDATA | Any | Inventory Data |
| LOCATION | ASCII | Location |

#### **S19F6 - Inventory Add Response** {#s19f6---inventory-add-response}
```
S19F6->
{L[2]
  INVID
  ACKC19
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| ACKC19 | U1 | Acknowledge Code |

#### **S19F7 - Inventory Remove Request** {#s19f7---inventory-remove-request}
```
<-S19F7
{L[2]
  INVTYPE
  INVID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVTYPE | ASCII | Inventory Type |
| INVID | ASCII | Inventory ID |

#### **S19F8 - Inventory Remove Response** {#s19f8---inventory-remove-response}
```
S19F8->
{L[2]
  INVID
  ACKC19
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| ACKC19 | U1 | Acknowledge Code |

#### **S19F9 - Inventory Status Request** {#s19f9---inventory-status-request}
```
<-S19F9
INVID
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |

#### **S19F10 - Inventory Status Response** {#s19f10---inventory-status-response}
```
S19F10->
{L[4]
  INVID
  INVSTATUS
  LOCATION
  INVDATA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| INVSTATUS | U1 | Inventory Status |
| LOCATION | ASCII | Location |
| INVDATA | Any | Inventory Data |

#### **S19F11 - Inventory Move Request** {#s19f11---inventory-move-request}
```
<-S19F11
{L[3]
  INVID
  SRCLOCATION
  DESTLOCATION
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| SRCLOCATION | ASCII | Source Location |
| DESTLOCATION | ASCII | Destination Location |

#### **S19F12 - Inventory Move Response** {#s19f12---inventory-move-response}
```
S19F12->
{L[2]
  INVID
  ACKC19
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| ACKC19 | U1 | Acknowledge Code |

#### **S19F13 - Inventory Search Request** {#s19f13---inventory-search-request}
```
<-S19F13
{L[n]
  SEARCHCRITERIA
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SEARCHCRITERIA | ASCII | Search Criteria |

#### **S19F14 - Inventory Search Response** {#s19f14---inventory-search-response}
```
S19F14->
{L[n]
  {L[3]
    INVID
    LOCATION
    INVDATA
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| LOCATION | ASCII | Location |
| INVDATA | Any | Inventory Data |

#### **S19F15 - Inventory Lock Request** {#s19f15---inventory-lock-request}
```
<-S19F15
{L[2]
  INVID
  LOCKTYPE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| LOCKTYPE | U1 | Lock Type |

#### **S19F16 - Inventory Lock Response** {#s19f16---inventory-lock-response}
```
S19F16->
{L[2]
  INVID
  LOCKSTATUS
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| LOCKSTATUS | U1 | Lock Status |

#### **S19F17 - Inventory History Request** {#s19f17---inventory-history-request}
```
<-S19F17
{L[3]
  INVID
  STARTTIME
  ENDTIME
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| STARTTIME | ASCII | Start Time |
| ENDTIME | ASCII | End Time |

#### **S19F18 - Inventory History Response** {#s19f18---inventory-history-response}
```
S19F18->
{L[n]
  {L[4]
    INVID
    TIMESTAMP
    ACTION
    DETAILS
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| INVID | ASCII | Inventory ID |
| TIMESTAMP | ASCII | Timestamp |
| ACTION | ASCII | Action |
| DETAILS | ASCII | Details |

#### **S19F19 - Inventory Audit Request** {#s19f19---inventory-audit-request}
```
<-S19F19
{L[2]
  AUDITTYPE
  AUDITPARAMS
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| AUDITTYPE | U1 | Audit Type |
| AUDITPARAMS | ASCII | Audit Parameters |

#### **S19F20 - Inventory Audit Response** {#s19f20---inventory-audit-response}
```
S19F20->
{L[2]
  AUDITSTATUS
  AUDITRESULTS
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| AUDITSTATUS | U1 | Audit Status |
| AUDITRESULTS | ASCII | Audit Results |

 



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
<-S20F1
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
S20F2->
SSAACK
```


#### **S20F3 - GetOperationIDList Request** {#s20f3---getoperationidlist-request}
```
<-S20F3
{L[3]
  OBJID
  OBJTYPE
  OPETYPE
}
```


#### **S20F4 - GetOperationIDList Acknowledge** {#s20f4---getoperationidlist-acknowledge}
```
S20F4->
{L[2]
  {L[n]
    OPEID
  }
  GOILACK
}
```


#### **S20F5 - OpenConnectionEvent Send** {#s20f5---openconnectionevent-send}
```
<-S20F5
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
S20F6->
{L[2]
  OPEID
  OCEACK
}
```


#### **S20F7 - CloseConnectionEvent Send** {#s20f7---closeconnectionevent-send}
```
<-S20F7
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F8 - CloseConnectionEvent Acknowledge** {#s20f8---closeconnectionevent-acknowledge}
```
<-S20F8
{L[2]
  OPEID
  CCEACK
}
```


#### **S20F9 - ClearOperation Request** {#s20f9---clearoperation-request}
```
<-S20F9
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F10 - ClearOperation Acknowledge** {#s20f10---clearoperation-acknowledge}
```
S20F10->
COACK
```


#### **S20F11 - GetRecipeXIDList Request** {#s20f11---getrecipexidlist-request}
```
<-S20F11
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```


#### **S20F12 - GetRecipeXIDList Acknowledge** {#s20f12---getrecipexidlist-acknowledge}
```
S20F12->
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
<-S20F13
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
S20F14->
DRRACK
```


#### **S20F15 - WriteRecipe Request** {#s20f15---writerecipe-request}
```
<-S20F15
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
S20F16->
WRACK
```


#### **S20F17 - ReadRecipe Request** {#s20f17---readrecipe-request}
```
<-S20F17
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
S20F18->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIMESTAMP | ASCII | Timestamp |
| OPEID | ASCII | Operation ID |
| ASSGNID | ASCII | Assignment ID |
| COPYID | ASCII | Copy ID |
| REVID | ASCII | Revision ID |
| RecID | ASCII | Recipe ID |
| VERID | ASCII | Version ID |
| TYPEID | ASCII | Type ID |
| EQID | ASCII | Equipment ID |
| RCPBODYA | ASCII | Recipe body data |
| RRACK_S20 | U1 | Read recipe acknowledge code |


#### **S20F19 - QueryRecipeXIDList Event Send** {#s20f19---queryrecipexidlist-event-send}
```
S20F19->
{L[4]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |


#### **S20F20 - QueryRecipeXIDList Event Acknowledge** {#s20f20---queryrecipexidlist-event-acknowledge}
```
<-S20F20
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OPEID | ASCII | Operation ID |
| TIMESTAMP | ASCII | Timestamp |
| ASSGNID | ASCII | Assignment ID |
| COPYID | ASCII | Copy ID |
| REVID | ASCII | Revision ID |
| RecID | ASCII | Recipe ID |
| VERID | ASCII | Version ID |
| TYPEID | ASCII | Type ID |
| EQID | ASCII | Equipment ID |
| QRXLEACK | U1 | Query recipe XID list event acknowledge |


#### **S20F21 - QueryRecipe Event Send** {#s20f21---queryrecipe-event-send}
```
S20F21->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |
| TIMESTAMP | ASCII | Timestamp |
| ASSGNID | ASCII | Assignment ID |
| COPYID | ASCII | Copy ID |
| REVID | ASCII | Revision ID |
| RecID | ASCII | Recipe ID |
| VERID | ASCII | Version ID |
| TYPEID | ASCII | Type ID |
| EQID | ASCII | Equipment ID |


#### **S20F22 - QueryRecipe Event Acknowledge** {#s20f22---queryrecipe-event-acknowledge}
```
<-S20F22
QREACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| QREACK | U1 | Query recipe event acknowledge |


#### **S20F23 - PostRecipe Event Send** {#s20f23---postrecipe-event-send}
```
S20F23->
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |
| PRJOBID | ASCII | Process job ID |
   


#### **S20F24 - PostRecipe Event Acknowledge** {#s20f24---postrecipe-event-acknowledge}
```
<-S20F24
PREACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PREACK | U1 | Post recipe event acknowledge |


#### **S20F25 - SetPRC Attributes Request** {#s20f25---setprc-attributes-request}
```
<-S20F25
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| MAXNUMBER | U4 | Maximum number |
| MAXTIME | U4 | Maximum time |
| PRCPREEXECHK | U1 | Recipe pre-execution check |


#### **S20F26 - SetPRC Attributes Acknowledge** {#s20f26---setprc-attributes-acknowledge}
```
S20F26->
SPAACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| SPAACK | U1 | Set PRC attributes acknowledge |


#### **S20F27 - PreSpecifyRecipe Request** {#s20f27---prespecifyrecipe-request}
```
<-S20F27
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |
| PRJOBID | ASCII | Process job ID |
| TIMESTAMP | ASCII | Timestamp |
| ASSGNID | ASCII | Assignment ID |
| COPYID | ASCII | Copy ID |
| REVID | ASCII | Revision ID |
| RecID | ASCII | Recipe ID |
| VERID | ASCII | Version ID |
| TYPEID | ASCII | Type ID |
| EQID | ASCII | Equipment ID | 
 

#### **S20F28 - PreSpecifyRecipe Acknowledge** {#s20f28---prespecifyrecipe-acknowledge}
```
S20F28->
PSRACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PSRACK | U1 | PreSpecifyRecipe acknowledge |


#### **S20F29 - QueryPJRecipeXIDList Event Send** {#s20f29---querypjrecipexidlist-event-send}
```
S20F29->
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |
| PRJOBID | ASCII | Process job ID |


#### **S20F30 - QueryPJRecipeXIDList Event Acknowledge** {#s20f30---querypjrecipexidlist-event-acknowledge}
```
<-S20F30
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| TIMESTAMP | ASCII | Timestamp |
| OPEID | ASCII | Operation ID |
| ASSGNID | ASCII | Assignment ID |
| COPYID | ASCII | Copy ID |
| REVID | ASCII | Revision ID |
| RecID | ASCII | Recipe ID |
| VERID | ASCII | Version ID |
| TYPEID | ASCII | Type ID |
| EQID | ASCII | Equipment ID |
| QPRKEACK | U1 | Query PJ recipe XID list event acknowledge |


#### **S20F31 - Pre-Exe Check Event Send** {#s20f31---pre-exe-check-event-send}
```
S20F31->
{L[6]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
  CHKINFO
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |
| PRJOBID | ASCII | Process job ID |
| CHKINFO | ASCII | Check information |


#### **S20F32 - Pre-Exe Check Event Acknowledge** {#s20f32---pre-exe-check-event-acknowledge}
```
<-S20F32
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PECRSLT | U1 | Pre-execution check result |
| TIMESTAMP | ASCII | Timestamp |
| OPEID | ASCII | Operation ID |
| ASSGNID | ASCII | Assignment ID |
| COPYID | ASCII | Copy ID |
| REVID | ASCII | Revision ID |
| RecID | ASCII | Recipe ID |
| VERID | ASCII | Version ID |
| TYPEID | ASCII | Type ID |
| EQID | ASCII | Equipment ID |
| RCPBODYA | ASCII | Recipe body data |
| PECEACK | U1 | Pre-execution check event acknowledge |


#### **S20F33 - PreSpecifyRecipe Event Send** {#s20f33---prespecifyrecipe-event-send}
```
S20F33->
{L[5]
  OBJID
  OBJTYPE
  OPETYPE
  OPEID
  PRJOBID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| OBJID | ASCII | Object ID |
| OBJTYPE | ASCII | Object type |
| OPETYPE | ASCII | Operation type |
| OPEID | ASCII | Operation ID |
| PRJOBID | ASCII | Process job ID |


#### **S20F34 - PreSpecifyRecipe Event Acknowledge** {#s20f34---prespecifyrecipe-event-acknowledge}
```
<-S20F34
PSREACK
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| PSREACK | U1 | PreSpecifyRecipe event acknowledge |



### Stream 21: Material Transfer Management
**Purpose**: High-level material transfer coordination

| Message | Direction | Description |
|---------|-----------|-------------|
| [S21F1](#s21f1---material-transfer-plan)   | → Equipment | Material Transfer Plan |
| [S21F2](#s21f2---material-transfer-plan-response)   | ← Equipment | Material Transfer Plan Response |
| [S21F3](#s21f3---item-send)   | → Equipment | Item Send |
| [S21F4](#s21f4---item-send-acknowledge)   | ← Equipment | Item Send Acknowledge |
| [S21F5](#s21f5---item-request)   | → Equipment | Item Request |
| [S21F6](#s21f6---item-data)   | ← Equipment | Item Data |
| [S21F7](#s21f7---item-type-list-request)   | → Equipment | Item Type List Request |
| [S21F8](#s21f8---item-type-list-results)   | ← Equipment | Item Type List Results |
| [S21F9](#s21f9---supported-item-type-list-request)   | → Equipment | Supported Item Type List Request |
| [S21F10](#s21f10---supported-item-type-list-result)   | ← Equipment | Supported Item Type List Result |
| [S21F11](#s21f11---item-delete)   | → Equipment | Item Delete |
| [S21F12](#s21f12---item-delete-acknowledge)   | ← Equipment | Item Delete Acknowledge |
| [S21F13](#s21f13---request-permission-to-send-item)   | → Equipment | Request Permission To Send Item |
| [S21F14](#s21f14---grant-permission-to-send-item)   | ← Equipment | Grant Permission To Send Item |
| [S21F15](#s21f15---item-request)   | → Equipment | Item Request |
| [S21F16](#s21f16---item-request-grant)   | ← Equipment | Item Request Grant |
| [S21F17](#s21f17---send-item-part)   | → Equipment | Send Item Part |
| [S21F18](#s21f18---send-item-part-acknowledge)   | ← Equipment | Send Item Part Acknowledge |
| [S21F19](#s21f19---item-type-feature-support)   | → Equipment | Item Type Feature Support |
| [S21F20](#s21f20---item-type-feature-support-results)   | ← Equipment | Item Type Feature Support Results |

#### **S21F1 - Material Transfer Plan** {#s21f1---material-transfer-plan}
```
<-S21F1
{L[4]
  ITEMTYPE
  ITEMID
  TRANSFERID
  TRANSFERINFO
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| TRANSFERID | ASCII | Transfer ID |
| TRANSFERINFO | ASCII | Transfer information |
  

#### **S21F2 - Material Transfer Plan Response** {#s21f2---material-transfer-plan-response}
```
S21F2->
{L[2]
  ITEMACK
  ITEMERROR
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |





#### **S21F3 - Item Send** {#s21f3---item-send}
```
<-S21F3
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMLENGTH | U4 | Item length |
| ITEMVERSION | ASCII | Item version |
| ITEMPART | Any | Item part |


#### **S21F4 - Item Send Acknowledge** {#s21f4---item-send-acknowledge}
```
S21F4->
{L[2]
  ITEMACK
  ITEMERROR
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |


#### **S21F5 - Item Request** {#s21f5---item-request}
```
<-S21F5
{L[2]
  ITEMTYPE
  ITEMID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |


#### **S21F6 - Item Data** {#s21f6---item-data}
```
S21F6->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMLENGTH | U4 | Item length |
| ITEMVERSION | ASCII | Item version |
| ITEMPART | Any | Item part |


#### **S21F7 - Item Type List Request** {#s21f7---item-type-list-request}
```
<-S21F7
ITEMTYPE
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |


#### **S21F8 - Item Type List Results** {#s21f8---item-type-list-results}
```
S21F8->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMLENGTH | U4 | Item length |
| ITEMVERSION | ASCII | Item version |


#### **S21F9 - Supported Item Type List Request** {#s21f9---supported-item-type-list-request}
```
<-S21F9
header only
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| Empty | - | Header only message |


#### **S21F10 - Supported Item Type List Result** {#s21f10---supported-item-type-list-result}
```
S21F10->
{L[3]
  ITEMACK
  ITEMERROR
  {L[n]
    ITEMTYPE
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |
| ITEMTYPE | ASCII | Item type |


#### **S21F11 - Item Delete** {#s21f11---item-delete}
```
<-S21F11
{L[2]
  ITEMTYPE
  {L[n]
    ITEMID
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |


#### **S21F12 - Item Delete Acknowledge** {#s21f12---item-delete-acknowledge}
```
S21F12->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMERROR | ASCII | Item error |


#### **S21F13 - Request Permission To Send Item** {#s21f13---request-permission-to-send-item}
```
<-S21F13
{L[5]
  ITEMTYPE
  ITEMID
  ITEMLENGTH
  ITEMVERSION
  ITEMPARTCOUNT
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMLENGTH | U4 | Item length |
| ITEMVERSION | ASCII | Item version |
| ITEMPARTCOUNT | U4 | Item part count |


#### **S21F14 - Grant Permission To Send Item** {#s21f14---grant-permission-to-send-item}
```
S21F14->
{L[2]
  ITEMACK
  ITEMERROR
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |


#### **S21F15 - Item Request** {#s21f15---item-request}
```
<-S21F15
{L[2]
  ITEMTYPE
  ITEMID
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |


#### **S21F16 - Item Request Grant** {#s21f16---item-request-grant}
```
S21F16->
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMLENGTH | U4 | Item length |
| ITEMVERSION | ASCII | Item version |
| ITEMPARTCOUNT | U4 | Item part count |


#### **S21F17 - Send Item Part** {#s21f17---send-item-part}
```
<-S21F17
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

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |
| ITEMID | ASCII | Item ID |
| ITEMLENGTH | U4 | Item length |
| ITEMVERSION | ASCII | Item version |
| ITEMINDEX | U4 | Item index |
| ITEMPARTCOUNT | U4 | Item part count |
| ITEMPARTLENGTH | U4 | Item part length |
| ITEMPART | Any | Item part |


#### **S21F18 - Send Item Part Acknowledge** {#s21f18---send-item-part-acknowledge}
```
S21F18->
{L[2]
  ITEMACK
  ITEMERROR
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |


#### **S21F19 - Item Type Feature Support** {#s21f19---item-type-feature-support}
```
<-S21F19
{L[n]
  ITEMTYPE
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMTYPE | ASCII | Item type |


#### **S21F20 - Item Type Feature Support Results** {#s21f20---item-type-feature-support-results}
```
S21F20->
{L[n]
  {L[4]
    ITEMACK
    ITEMERROR
    ITEMTYPE
    ITEMTYPESUPPORT
  }
}
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| ITEMACK | U1 | Item acknowledge |
| ITEMERROR | ASCII | Item error |
| ITEMTYPE | ASCII | Item type |
| ITEMTYPESUPPORT | U1 | Item type support |

