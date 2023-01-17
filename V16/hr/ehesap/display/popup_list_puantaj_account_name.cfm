<cfquery name="get_odenek" datasource="#dsn#">
	SELECT 
		SO.*
	FROM 
		SETUP_PAYMENT_INTERRUPTION SO
	WHERE 
		SO.IS_ODENEK = 1 AND
		SO.STATUS = 1
	ORDER BY
		COMMENT_PAY
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Bordro Karşılığı',54292)#" settings="0" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_seperator id="account_item" header="#getLang('','Hesap Kalemleri',46439)#">
	<cf_grid_list id="account_item">
		<tbody>
			<cfloop list="#puantaj_account_name_list()#" index="i">
				<cfset b = trim(listfirst(i,';'))>
				<cfset a = trim(listlast(i,';'))>
				<cfoutput>
				<tr>
					<td><a href="javascript://" onClick="gonder('#a#','#b#',0)">#trim(a)#</a></td>
				</tr>		
				</cfoutput>
			</cfloop>
		</tbody>
	</cf_grid_list>
	<cf_seperator id="expense_item" header="#getLang('','Harcırah Kalemleri',46428)#">
	<cf_grid_list id="expense_item">
		<tbody>
			<cfloop list="#puantaj_account_name_list2()#" index="i">
				<cfset b = trim(listfirst(i,';'))>
				<cfset a = trim(listlast(i,';'))>
				<cfoutput>
				<tr>
					<td><a href="javascript://" onClick="gonder('#a#','#b#',3)">#trim(a)#</a></td>
				</tr>		
				</cfoutput>
			</cfloop>
		</tbody>
	</cf_grid_list>
	<cfif get_odenek.recordcount>
		<cf_seperator id="odkes_item" header="#getLang('','Ek Ödenekler',53399)#">
		<cf_grid_list id="odkes_item">
			<tbody>
				<cfoutput query="get_odenek">
					<tr>
						<td><a href="javascript://" onClick="gonder('#comment_pay#','#ODKES_ID#',1)">#comment_pay#</a></td>
					</tr>	
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_seperator id="odkes_item_net" header="#getLang('','Ek Ödenekler(Net)',46426)#">
		<cf_grid_list id="odkes_item_net">
			<tbody>
				<cfoutput query="get_odenek">
					<tr>
						<td><a href="javascript://" onClick="gonder('#comment_pay#','#ODKES_ID#',2)">#comment_pay#</a></td>
					</tr>	
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</cfif>
	<cf_seperator id="officer_item" header="#getLang('','Memur Hesap Kalemleri',64598)#">
	<cf_grid_list id="officer_item">
		<tbody>
			<cfloop list="#officer_account_name_list()#" index="i">
				<cfset b = trim(listfirst(i,';'))>
				<cfset a = trim(listlast(i,';'))>
				<cfoutput>
				<tr>
					<td><a href="javascript://" onClick="gonder('#a#','#b#',3)">#trim(a)#</a></td>
				</tr>		
				</cfoutput>
			</cfloop>
		</tbody>
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
	function gonder(name,id,type)
	{
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
		<cfif isdefined("attributes.field_detail")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_detail#</cfoutput>.value=name;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_net_detail#</cfoutput>.value="";
		</cfif>
		<cfif isdefined("attributes.field_id")>
			if(type == 0 || type == 3)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
			else
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=name;
		</cfif>
		<cfif isdefined("attributes.field_kesinti_id")>
			if(type == 1 || type == 2)
			{
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_kesinti_id#</cfoutput>.value=id;
				if(type == 1)
					{
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_net#</cfoutput>.value=0;
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_net_detail#</cfoutput>.value="";
						
					}
				else
					{
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_net#</cfoutput>.value=1;
							<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_net_detail#</cfoutput>.value="Net";
					}
			}
		</cfif>
		if(type == 3) //harcırah bordrosu kalemleri
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_expense#</cfoutput>.value=1;	
		}
		else
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_expense#</cfoutput>.value=0;	
		}
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
