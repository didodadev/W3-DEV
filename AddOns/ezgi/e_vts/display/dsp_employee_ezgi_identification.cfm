<cfparam name="attributes.deliver_code" default="">
<cfparam name="attributes.station_id" default="">

<cfquery name="get_deliver_name" datasource="#dsn3#">

    SELECT     	
    	E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS DELIVER_NAME,
     	E.EMPLOYEE_ID
    FROM       	
    	EZGI_VTS_IDENTY AS EV INNER JOIN
     	#dsn_alias#.EMPLOYEES AS E ON EV.EMP_ID = E.EMPLOYEE_ID
	WHERE        
    	EV.PAROLA = '#attributes.deliver_code#'
</cfquery>
<cfquery name="get_station_temp" datasource="#dsn3#">
   	SELECT     
    	TOP (1) STATION_ID,
        (SELECT UP_STATION FROM WORKSTATIONS WHERE STATION_ID = PRODUCTION_OPERATION_RESULT.STATION_ID) AS UP_STATION
	FROM         
    	PRODUCTION_OPERATION_RESULT
	WHERE     
    	ACTION_EMPLOYEE_ID = #GET_DELIVER_NAME.EMPLOYEE_ID#
	ORDER BY 
    	ACTION_START_DATE DESC		
</cfquery>
<cfif not get_station_temp.recordcount>
	<cfquery name="get_station_temp" datasource="#dsn3#">
		SELECT
        	TOP (1)     	
            UP_STATION,
            STATION_ID 
        FROM       	
            WORKSTATIONS
        WHERE     	
            DEPARTMENT = (SELECT DEFAULT_DEPARTMENT_ID FROM #dsn3_alias#.EZGI_VTS_IDENTY WHERE EMP_ID = #get_deliver_name.EMPLOYEE_ID#) AND
            ACTIVE = 1 AND
            UP_STATION IS NOT NULL
        ORDER BY
            STATION_NAME 
   	</cfquery>
</cfif>
<cfquery name="get_workstation" datasource="#dsn3#">
    SELECT     	
    	STATION_ID, 
    	UP_STATION, 
        STATION_NAME
    FROM       	
    	WORKSTATIONS
    WHERE     	
    	DEPARTMENT = (SELECT DEFAULT_DEPARTMENT_ID FROM #dsn3_alias#.EZGI_VTS_IDENTY WHERE EMP_ID = #get_deliver_name.EMPLOYEE_ID#) AND
        ACTIVE = 1
  	ORDER BY
    	STATION_NAME              
</cfquery>
<cfquery name="get_up_workstation" dbtype="query">
    SELECT     	
    	STATION_ID, 
    	UP_STATION, 
        STATION_NAME
    FROM       	
    	get_workstation
    WHERE     	
    	UP_STATION IS NULL
  	ORDER BY
    	STATION_NAME              
</cfquery>
<cfquery name="get_down_workstation" dbtype="query">
    SELECT     	
    	STATION_ID, 
    	UP_STATION, 
        STATION_NAME
    FROM       	
    	get_workstation
    WHERE     	
    	UP_STATION = #get_station_temp.UP_STATION#
  	ORDER BY
    	STATION_NAME              
</cfquery>

<cfquery name="get_prod_pause" datasource="#dsn3#">
	SELECT     
    	P_ORDER_ID, 
        STATION_ID, 
        EMPLOYEE_ID, 
        OPERATION_ID
	FROM         
    	SETUP_PROD_PAUSE
	WHERE     
    	PROD_DURATION IS NULL AND 
        EMPLOYEE_ID = #GET_DELIVER_NAME.EMPLOYEE_ID#
</cfquery>
<cfif get_prod_pause.recordcount and len(get_prod_pause.P_ORDER_ID)>
	<script type="text/javascript">	
		window.location.href='<cfoutput>#request.self#?fuseaction=production.add_ezgi_production_order&upd=#get_prod_pause.P_ORDER_ID#&station_id=#get_prod_pause.STATION_ID#&employee_id=#get_prod_pause.EMPLOYEE_ID#&p_operation_id=#get_prod_pause.OPERATION_ID#&start_date=#Dateformat(now(),'DD/MM/YYYY')#</cfoutput>';
	</script>
</cfif>
<cfquery name="get_station_employee" datasource="#dsn3#">
	SELECT     
    	TOP (1) STATION_ID, 
        EMPLOYEE_ID, 
        START_DATE, 
        FINISH_DATE
	FROM         
    	EZGI_STATION_EMPLOYEE
	WHERE     
    	EMPLOYEE_ID = #GET_DELIVER_NAME.EMPLOYEE_ID#
	ORDER BY 
    	START_DATE desc
</cfquery>
<cfif get_station_employee.recordcount and not len(get_station_employee.FINISH_DATE)>
	<script type="text/javascript">	
		window.location.href='<cfoutput>#request.self#?fuseaction=production.list_ezgi_production_operation&station_id=#get_station_employee.STATION_ID#&employee_id=#get_station_employee.EMPLOYEE_ID#</cfoutput>';
	</script>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" style="width:100%; height:100%">
	<tr>
		<td>
            <table cellspacing="0" cellpadding="1" border="0" style="height:100%; width:100%; vertical-align:middle">
                <cfform name="form_station" method="post" action="#request.self#?fuseaction=production.list_ezgi_production_operation" >
                <tr class="color-border">
                    <td style="height:95%; width:95%; vertical-align:middle">
                        <table cellspacing="0" cellpadding="0" border="0" style="height:100%; width:100%; vertical-align:middle">
                            <tr class="color-row">
                                <td style="width:100%; height:100%; vertical-align:middle">
                                    <cfoutput>
                                    <table style="height:100%; width:100%; vertical-align:middle">
                                    	<tr>
                                        	<td colspan="2" style=" height:280px">&nbsp;</td>
                                       	</tr>
                                     	<tr>
                                        	<td style="font-size:18px; height:30px; text-align:right; vertical-align:middle; width:40%">
                                            	Operatör &nbsp;&nbsp;
                                            </td>
                                        	<td style="font-size:18px; text-align:left; vertical-align:vidlle">
                                            	<cfoutput>#get_deliver_name.deliver_name#</cfoutput>
                                            </td>
                                       	</tr>
                                        <tr>
                                        	<td style="font-size:18px; height:30px; text-align:right; vertical-align:middle;">
                                            	Bölüm &nbsp;&nbsp;
                                            </td>
                                        	<td style="font-size:18px; text-align:left; vertical-align:middle">
                                               	<select name="up_station_id" id="up_station_id" style="width:300px; height:30px;font-size:18px" onchange="station_select(this.value);">
                                                    <cfloop query="get_up_workstation">
                                                    	<option value="#station_id#" <cfif station_id eq get_station_temp.up_station>selected</cfif>>#STATION_NAME#</option>
                                                  	</cfloop>
                                               	</select>
                                            </td>
                                   		</tr>
                                        <tr>
                                        	<td style="font-size:18px; height:30px; text-align:right; vertical-align:middle;">
                                            	Makina &nbsp;&nbsp;
                                            </td>
                                        	<td style="font-size:18px; text-align:left; vertical-align:middle">
                                               	<select name="station_id" id="station_id" style="width:300px; height:30px;font-size:18px">
                                                    <cfloop query="get_down_workstation">
                                                    	<option value="#station_id#" <cfif station_id eq get_station_temp.station_id>selected</cfif>>#STATION_NAME#</option>
                                                  	</cfloop>
                                               	</select>&nbsp;
                                                <input type="submit" name="button" id="button" value="#getLang('objects2',1135)#" style="height:30px;width:70px; vertical-align:middle" onclick="kontrol()" />
                                            </td>
                                   		</tr>
                                        <tr>
                                        	<td colspan="2" style=" height:280px">&nbsp;</td>
                                       	</tr>
                                        <input type="hidden" name="employee_id" value="<cfoutput>#get_deliver_name.employee_id#</cfoutput>">
                                        <input type="hidden" name="new_employee" value="1" />
                                  	</table>
                              		</cfoutput>
								</td>
                         	</tr>
                    	</table>
                  	</td>
              	</tr>
           	</cfform>
            </table>
     	</td>
   	</tr>
    
</table>

<script language="javascript">
	function kontrol()
	{
		if ((document.form_station.station_id.value) == '')
		{
			alert('<cf_get_lang_main no='3115.Bir Makina Seçiniz'>');
			return false;
		}
	}
	function station_select(abc)
	{
		var station_names = 
		wrk_query("SELECT STATION_ID,UP_STATION,STATION_NAME FROM WORKSTATIONS WHERE UP_STATION = "+abc+" ORDER BY STATION_NAME","dsn3");
		var option_count = document.getElementById('station_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('station_id').options[x] = null;
		if(station_names.recordcount != 0)
		{	
			document.getElementById('station_id').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<station_names.recordcount;xx++)
				document.getElementById('station_id').options[xx+1]=new Option(station_names.STATION_NAME[xx],station_names.STATION_ID[xx],station_names.UP_STATION[xx]);
		}
		else
			document.getElementById('station_id').options[0] = new Option('Seçiniz','');
	}
</script>
