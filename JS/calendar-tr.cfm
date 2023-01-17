<cfquery name="GET_CALENDER_OFFTIMES_" datasource="#DSN#">
	SELECT
		START_DATE,
		FINISH_DATE,
		OFFTIME_NAME
	FROM 
		SETUP_GENERAL_OFFTIMES
	ORDER BY
		START_DATE
</cfquery>
	var DATE_INFO = 
	{
	<cfif get_calender_offtimes_.recordcount>
		<cfoutput query="get_calender_offtimes_">
			<cfset off_name_ = offtime_name>
			<cfset day_count = DateDiff("d",get_calender_offtimes_.start_date,get_calender_offtimes_.finish_date) + 1>
				<cfloop index="k" from="1" to="#day_count#">
					<cfset current_day = date_add("d", k-1, get_calender_offtimes_.start_date)>
					<cfif not (year(now()) eq year(current_day) and month(now()) eq month(current_day) and day(now()) eq day(current_day))>
						#dateformat(current_day,'yyyymmdd')# : { klass: "highlight", tooltip: "#offtime_name#"},
					</cfif>
				</cfloop>
		</cfoutput>
	</cfif>
	<cfoutput>#dateformat(now(),'yyyymmdd')# : { klass: "highlight2", tooltip: "<cf_get_lang_main no='530.Bugun'>"}</cfoutput>
	};
	<cfoutput>
	function getDateInfo(date, wantsClassName) 
	{
	  var as_number = Calendar.dateToInt(date);
	  return DATE_INFO[as_number];
	}
		
	Calendar.LANG("en", "English",
		 {
			goToday: "<cf_get_lang_main no='556.Bugune Git'>",
			today: "<cf_get_lang_main no='530.Bugun'>",         // appears in bottom bar
			wk: "<cf_get_lang_main no='1908.Hf'>",
			<cfif isdefined("session.ep.week_start") and session.ep.week_start eq 0>
				fdow: 0,// first day of week for this locale;0 = Sunday
				weekend: "5,6",//hafta sonları cuma cumartesi
			<cfelse>
				fdow: 1,// first day of week for this locale;1 = Monday
				weekend: "0,6",//hafta sonları cumartesi pazar
			</cfif>
			AM: "am",
			PM: "pm",
			mn : [ "<cf_get_lang_main no='180.Ocak'>",
				   "<cf_get_lang_main no='181.Subat'>",
				   "<cf_get_lang_main no='182.Mart'>",
				   "<cf_get_lang_main no='183.Nisan'>",
				   "<cf_get_lang_main no='184.Mayis'>",
				   "<cf_get_lang_main no='185.Haziran'>",
				   "<cf_get_lang_main no='186.Temmuz'>",
				   "<cf_get_lang_main no='187.Agustos'>",
				   "<cf_get_lang_main no='188.Eylul'>",
				   "<cf_get_lang_main no='189.Ekim'>",
				   "<cf_get_lang_main no='190.Kasim'>",
				   "<cf_get_lang_main no='191.Aralik'>" ],
	
			smn : [ "<cf_get_lang_main no='541.Oca'>",
					"<cf_get_lang_main no='542.Şub'>",
					"<cf_get_lang_main no='543.Mar'>",
					"<cf_get_lang_main no='544.Nis'>",
					"<cf_get_lang_main no='545.May'>",
					"<cf_get_lang_main no='546.Haz'>",
					"<cf_get_lang_main no='547.Tem'>",
					"<cf_get_lang_main no='548.Agu'>",
					"<cf_get_lang_main no='549.Eyl'>",
					"<cf_get_lang_main no='550.Eki'>",
					"<cf_get_lang_main no='551.Kas'>",
					"<cf_get_lang dictionary_id='951.Ara'>" ],
	
			dn : [ "<cf_get_lang_main no='198.Pazar'>",
				   "<cf_get_lang_main no='192.Pazartesi'>",
				   "<cf_get_lang_main no='193.Salı'>",
				   "<cf_get_lang_main no='194.Çarşamba'>",
				   "<cf_get_lang_main no='195.Perşembe'>",
				   "<cf_get_lang_main no='196.Cuma'>",
				   "<cf_get_lang_main no='197.Cumartesi'>",
				   "<cf_get_lang_main no='198.Pazar'>" ],
	
			sdn : [ "<cf_get_lang_main no='1901.Sn'>","<cf_get_lang_main no='1902.Mn'>","<cf_get_lang_main no='1903.Te'>","<cf_get_lang_main no='1904.Wd'>","<cf_get_lang_main no='1905.Th'>","<cf_get_lang_main no='211.Fr'>","<cf_get_lang_main no='1907.St'>","<cf_get_lang_main no='1901.Sn'>" ]
	});
</cfoutput>
