<cfquery name="GET_CONS_INFO" datasource="#DSN#">
	SELECT CONSUMER_STATUS,MEMBER_CODE,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.cid#
</cfquery>
<cf_get_lang dictionary_id ='57586.Bireysel Üye'> : <cfoutput><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.cid#" >#get_cons_info.consumer_name#&nbsp;#get_cons_info.consumer_surname# <cfif len(get_cons_info.member_code)>/ #get_cons_info.member_code#</cfif></cfoutput>

