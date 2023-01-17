<cfset add_mail_template = createObject("component", "V16.settings.cfc.mail_company_settings")>
<cfset cont = ReplaceList(attributes.template_content,chr(13),'')>
<cfset cont = ReplaceList(cont,chr(10),'')>
<cfset cont = ReplaceList(cont,"'","""")>

<cfset Insert = add_mail_template.InsertTemplate(
    TEMPLATE_NAME : attributes.template_name,
    TEMPLATE_SUBJECT : attributes.template_subject,
    TEMPLATE_CONTENT : "#cont#"
)/>

<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_mail_companies&event=updMailTemplate&tid=#Insert.IDENTITYCOL#'
    </cfoutput>
</script>