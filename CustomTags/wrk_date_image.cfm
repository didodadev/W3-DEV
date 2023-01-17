<!--- 
Description : takvim

Parameters :

Syntax :
	<cf_wrk_date_image>
	call_function : not required
	control_date: dönem kısıtına göre kontrol edilcek tarih
	date_form : formun adı gönderilir
	title: not required
created :
	YO20070214
Bl --> bottom left
Tl --> top left
M --> center

gereken durumlarda pozisyon degistirilebilir
--->

<cfif not isdefined("caller.lang_array_main.item")>
	<cfset caller = caller.caller>
</cfif>

<cfparam name="attributes.function_currency_type" default="">
<cfparam name="attributes.c_position" default="Br">
<cfparam name="attributes.readonly" default="false">
<cfparam name="attributes.noShow" default="0">
<cfscript>
	if(not isdefined("caller.dateformat_style"))
	caller.dateformat_style = caller.caller.dateformat_style;
	if(not isdefined("caller.timeformat_style"))
	caller.timeformat_style = caller.caller.timeformat_style;
	if(isdefined("attributes.control_date")){
		temp = attributes.control_date;
		if(caller.dateformat_style is 'dd/mm/yyyy')
		{
			yil = listgetat(temp,3,"/");
			ay  = listgetat(temp,2,"/");
			gun = listgetat(temp,1,"/");
		}
		else
		{
			yil = listgetat(temp,3,"/");
			ay  = listgetat(temp,1,"/");
			gun = listgetat(temp,2,"/");
		}  
	}
</cfscript>
<cfif not isdefined('attributes.control_date') or (not len(caller.session.ep.period_date) or datediff('d',createdate(yil,ay,gun),createdate(listgetat(caller.session.ep.period_date,1,'-'),listgetat(caller.session.ep.period_date,2,'-'),listgetat(caller.session.ep.period_date,3,'-'))) lte 0)>
	<cfif not isdefined("attributes.date_form")>
		<span class="date-group">
		<i class="fa fa-calendar" id="<cfoutput>#attributes.date_field#_image</cfoutput>" alt="<cfif not isdefined("attributes.alt")><cfoutput>Tarih</cfoutput><cfelse><cfoutput>#attributes.alt#</cfoutput></cfif>" <cfif isDefined("attributes.title")>title="<cfoutput>#attributes.title#</cfoutput>"</cfif> >
			<i class="icon-date-number"><!--- <cfoutput>#Day(NOW())#</cfoutput> ---></i> 
		</i>
		</span>
	<cfelse>
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender&alan=#attributes.date_form#.#attributes.date_field#<cfif isdefined("attributes.call_function")>&call_function=#attributes.call_function#</cfif><cfif isdefined("attributes.call_parameter")>&call_parameter=#attributes.call_parameter#</cfif></cfoutput>','date');">
        <i class="fa fa-calendar"></i>
        </a>
	</cfif>
    <cfif not isdefined("attributes.date_form")>
	<script type="text/javascript" language="JavaScript">
		<cfif isdefined("attributes.call_function")>
		function this_get_function_<cfoutput>#attributes.date_field#</cfoutput>(cal,date)
		{ 
		   var field = document.getElementById('<cfoutput>#attributes.date_field#</cfoutput>'); 
		   if(field) 
		   { 
			<cfif listlen(attributes.call_function,'&') eq 1 and attributes.call_function is 'change_money_info'>
				form_name = document.all.<cfoutput>#attributes.date_field#</cfoutput>.form.name;
				change_money_info(form_name,'<cfoutput>#attributes.date_field#</cfoutput>','<cfoutput>#attributes.function_currency_type#</cfoutput>'); 
			<cfelseif listlen(attributes.call_function,'&') gt 1>
				<cfloop list="#attributes.call_function#" index="fonk_form_name" delimiters="&">
					<cfif fonk_form_name is 'change_money_info'>
						form_name = document.all.<cfoutput>#attributes.date_field#</cfoutput>.form.name;
						change_money_info(form_name,'<cfoutput>#attributes.date_field#</cfoutput>','<cfoutput>#attributes.function_currency_type#</cfoutput>');
					<cfelse>
						<cfif listlen(attributes.call_function,'(') gt 1>
							<cfoutput>#fonk_form_name#</cfoutput>;
						<cfelse>
							<cfoutput>#fonk_form_name#</cfoutput>();
						</cfif>
						
					</cfif>
				</cfloop>
			<cfelse>
				<cfif isdefined("attributes.call_parameter")>
					<cfoutput>#attributes.call_function#(#attributes.call_parameter#)</cfoutput>;
				<cfelse>
					<cfoutput>#attributes.call_function#</cfoutput>();
				</cfif>
			</cfif>
		   }
		}
		</cfif>
		function close_wrk_d_image_<cfoutput>#attributes.date_field#</cfoutput>()
		{
			if(document.getElementById('<cfoutput>#attributes.date_field#</cfoutput>').getAttribute("onchange"))
			{
				document.getElementById('<cfoutput>#attributes.date_field#</cfoutput>').onchange();	
			}		
		}
	</script>
	</cfif>	
	<cfif not isdefined("attributes.date_form")>
		<script type="text/javascript">
				Calendar.setup({
				animation :false,
				weekNumbers : true,
				inputField     :    "<cfoutput>#attributes.date_field#</cfoutput>",
				trigger    	   : 	"<cfoutput>#attributes.date_field#</cfoutput>_image",
				<cfif caller.dateformat_style is 'dd/mm/yyyy'>
					dateFormat     :    "%d/%m/%Y", // format of the input field "%B %e, %Y"
				<cfelse>
					dateFormat     :    "%m/%d/%Y", // format of the input field "%B %e, %Y"
				</cfif>	
				onSelect	   :	function() {<cfif isdefined("attributes.call_function")>this_get_function_<cfoutput>#attributes.date_field#</cfoutput>(); close_wrk_d_image_<cfoutput>#attributes.date_field#</cfoutput>(); this.hide();<cfelse>close_wrk_d_image_<cfoutput>#attributes.date_field#</cfoutput>();this.hide();</cfif>},
				<cfif isdefined("attributes.min_date")>
					min: <cfoutput>#attributes.min_date#</cfoutput>,
				</cfif>
				<cfif isdefined("attributes.max_date")>
					max: <cfoutput>#attributes.max_date#</cfoutput>,
				</cfif>
				singleClick    :  true,
				dateInfo : getDateInfo
				});
				<cfif (isdefined("attributes.min_date") or isdefined("attributes.max_date")) and attributes.readonly is true>
					document.getElementById('<cfoutput>#attributes.date_field#</cfoutput>').setAttribute("readonly","readonly");
				</cfif>
		</script>
	</cfif>
    <cfif attributes.noShow eq 1>
    	<script type="text/javascript">
			 $(function(){
				 $("input#<cfoutput>#attributes.date_field#</cfoutput>").after('<span id="<cfoutput>#attributes.date_field#</cfoutput>_span" class="input-group-addon"></span>');
				 $("#<cfoutput>#attributes.date_field#</cfoutput>_image").appendTo($("#<cfoutput>#attributes.date_field#</cfoutput>_span"));
			 });
         </script>
    </cfif>
<cfelse>
	<i class="fa fa-calendar" id="<cfoutput>#attributes.date_field#_image</cfoutput>" alt="<cfoutput>#dateformat(caller.session.ep.period_date,'dd/mm/yyyy')#</cfoutput><cf_get_lang dictionary_id="52640.Öncesinde İşlem Yapamazsınız">!" onclick="alert('<cfoutput>#dateformat(caller.session.ep.period_date,'dd/mm/yyyy')#</cfoutput><cf_get_lang dictionary_id="52640.Öncesinde İşlem Yapamazsınız">!');"></i>
</cfif>
