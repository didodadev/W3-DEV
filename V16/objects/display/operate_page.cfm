<!--- 
Description :
   operates print,fax,pdf and mail processes for html contents

Parameters :
	module       ==> Module name -- required
	operation    ==> operation name -- required
	action       ==> action names : print,fax,pdf or mail -- required
	id           ==> operation id -- required
	caption      ==> subject or header for fax or mail actions -- required for fax and mail
	ccs          ==> 'Bilgi Verilecekler' mail list if there exists -- only for mail action and optional

syntax : #request.self#?fuseaction=objects.popup_operate_page&operation=<operation name>&action=<print,fax,pdf or mail>&id=<operation id>&module=<Module name>&caption=<form name>.<subject or header field name>&ccs=<mails>
sample1 : #request.self#?fuseaction=objects.popup_operate_page&operation=offer&action=print&id=#url.offer_id#&module=sales
sample2 : #request.self#?fuseaction=objects.popup_operate_page&operation=offer&action=mail&id=#url.offer_id#&module=sales&caption=upd_offer_product.offer_head&<cfif Len(mails)>&ccs=#Left(mails,Len(mails)-1)#</cfif>
sample3 : #request.self#?fuseaction=objects.popup_operate_page&operation=offer&action=pdf&id=#url.offer_id#&module=sales
sample4 : #request.self#?fuseaction=objects.popup_operate_page&operation=offer&action=fax&id=#url.offer_id#&module=sales&caption=upd_offer_product.offer_head

Note : Templates must be included in the 'dsp_template.cfm'
 --->
<!--- Menü Başladı --->
<cfsavecontent variable="right">
	<cfscript>						
		popup_ext = "";
		query_ext = "&iframe=1";
		if(attributes.action is 'mail'){
			popup_ext = "mail_detail";
			if(isDefined("ccs"))
				popup_ext = popup_ext & "&ccs=#ccs#";
		}
		else
			popup_ext = "operate_action";
		if((attributes.operation is 'list_report_choosen') or 
		   (attributes.operation contains 'temp_conditions') or
		   (attributes.operation contains 'collacted_product_prices'))
			query_ext = page_code;
		else
			query_ext = "&operation=#attributes.operation#&action=#attributes.action#&id=#attributes.id#&module=#attributes.module#";
		if(fuseaction contains 'full_operations')
			query_ext = query_ext & "&full_operations";
		if(isdefined("attributes.trail"))
			query_ext = query_ext & "&trail=#attributes.trail#";
		if(isDefined("attributes.type"))
			query_ext = query_ext & "&type=#attributes.type#";
	</cfscript>	
	<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects.popup_#popup_ext##query_ext#','<cfif attributes.action is 'print'>page<cfelse>small</cfif>');</cfoutput>">
	<cfif attributes.action eq 'mail'><img src="/images/mail.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0">
	<cfelseif attributes.action eq 'excel'><img src="/images/excel.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0">
	<cfelseif attributes.action eq 'print'><img src="/images/print.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0">
	<cfelseif attributes.action eq 'fax'><img src="/images/fax.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0">
	<cfelseif attributes.action eq 'pdf'><img src="/images/pdf.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0">
	<cfelseif attributes.action eq 'valid'><img src="/images/valid.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0"></cfif></a>
</cfsavecontent>
<cfif not isdefined("attributes.trail")><cfset attributes.trail = 1></cfif>
<cfif attributes.action eq 'mail'>
	<form name="operations" id="operations" method="post">
		<input type="hidden" name="to_id" id="to_id">
		<input type="hidden" name="cc_id" id="cc_id">
		<input type="hidden" name="subject" id="subject">	
	</form>
	<script type="text/javascript">
		<cfif isDefined("attributes.caption")>	
		document.operations.subject.value = window.opener.<cfoutput>#attributes.caption#</cfoutput>.value;
		</cfif>	
	</script>
</cfif>
<!--- Menü Bitti --->
<cfinclude template="dsp_template.cfm">
