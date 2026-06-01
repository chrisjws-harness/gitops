{{- define "podinfo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "podinfo.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "podinfo.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "podinfo.labels" -}}
app.kubernetes.io/name: {{ include "podinfo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "podinfo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "podinfo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
