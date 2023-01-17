<cfset del_mail_account = createObject("component", "V16.settings.cfc.mail_accounts_settings")>
<cfset Delete = del_mail_account.Delete(
    MAIL_ACCOUNT_ID : attributes.maid
)/>
<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_mail_accounts'
    </cfoutput>
</script>