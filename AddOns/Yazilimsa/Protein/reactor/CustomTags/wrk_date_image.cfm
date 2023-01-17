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
	<cftry>
		<cfset caller = caller>
		<cfcatch type="exception">
			<cfset caller = caller.caller>			
		</cfcatch>
	</cftry>	
</cfif>

<cfparam name="attributes.function_currency_type" default="">
<cfparam name="attributes.c_position" default="Br">
<cfparam name="attributes.readonly" default="false">
<cfparam name="attributes.noShow" default="0">
<cfif not isdefined('attributes.control_date') or (not len(caller.session.ep.period_date) or datediff('d',createdate(listgetat(attributes.control_date,3,'/'),listgetat(attributes.control_date,2,'/'),listgetat(attributes.control_date,1,'/')),createdate(listgetat(caller.session.ep.period_date,1,'-'),listgetat(caller.session.ep.period_date,2,'-'),listgetat(caller.session.ep.period_date,3,'-'))) lte 0)>
	<cfif not isdefined("attributes.date_form")>
		<span class="icon-calendar" id="<cfoutput>#attributes.date_field#_image</cfoutput>" alt="<cfif not isdefined("attributes.alt")><cfoutput>Tarih</cfoutput><cfelse><cfoutput>#attributes.alt#</cfoutput></cfif>" <cfif isDefined("attributes.title")>title="<cfoutput>#attributes.title#</cfoutput>"</cfif>><i class="far fa-calendar-alt"></i></span>
	<cfelse>
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender&alan=#attributes.date_form#.#attributes.date_field#<cfif isdefined("attributes.call_function")>&call_function=#attributes.call_function#</cfif><cfif isdefined("attributes.call_parameter")>&call_parameter=#attributes.call_parameter#</cfif></cfoutput>','date');">
        <i class="far fa-calendar-alt"></i>
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
						<cfoutput>#fonk_form_name#</cfoutput>();
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
				dateFormat     :    "%d/%m/%Y",
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
	<i class="icon-calendar-o" id="<cfoutput>#attributes.date_field#_image</cfoutput>" alt="<cfoutput>#dateformat(caller.session.ep.period_date,'dd/mm/yyyy')#</cfoutput> Öncesinde İşlem Yapamazsınız!" onclick="alert('<cfoutput>#dateformat(caller.session.ep.period_date,'dd/mm/yyyy')#</cfoutput> Öncesinde İşlem Yapamazsınız!');"></i>
</cfif>
