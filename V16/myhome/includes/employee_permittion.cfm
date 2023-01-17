<cfsetting showdebugoutput="no">
<!--- Gundem Sayfasinda Izne Ayrilacaklar, Xmlde Secilen Tarih Araligina Gore Getirilir FBS 20111101 --->
<cfset Today = CreateDate(Year(Now()),Month(Now()),Day(Now()))>
<cfset Today_ = DateAdd("h",-1*session.ep.time_zone,Today)>
<cfif not (isDefined("xml_show_offtime_days") or isDefined("attributes.xml_show_offtime_days"))>
	<cfset xml_show_offtime_days = 1>
<cfelseif isDefined("attributes.xml_show_offtime_days")>
	<cfset xml_show_offtime_days = attributes.xml_show_offtime_days>
</cfif>
<CFSET attributes.STARTDATE = dateadd('d',0,today_)>
<CFSET attributes.FINISHDATE = dateadd('d',xml_show_offtime_days,today_)>
<cfquery name="get_offtime" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		O.STARTDATE,
		O.FINISHDATE,
		O.WORK_STARTDATE,
		SO.OFFTIMECAT,
		CASE 
            WHEN ISNULL(O.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = O.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(O.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = O.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME
	FROM
		EMPLOYEES E,
		OFFTIME O,
		SETUP_OFFTIME SO
	WHERE
		O.VALID = 1 AND
		(
			(
			O.STARTDATE >= #attributes.STARTDATE# AND
			O.STARTDATE < #DATEADD("d",1,attributes.FINISHDATE)#
			)
		OR
			(
			O.STARTDATE <= #attributes.STARTDATE# AND
			O.FINISHDATE >= #attributes.STARTDATE#
			)
		) AND
		SO.OFFTIMECAT_ID = O.OFFTIMECAT_ID AND
		E.EMPLOYEE_ID = O.EMPLOYEE_ID
	ORDER BY
		O.FINISHDATE
</cfquery>
<cf_flat_list>
	<tbody>
		<cfif get_offtime.recordcount>
			<cfoutput query="get_offtime">
				<tr>
					<td colspan="2"><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');"><font style="color:<cfif DateDiff('d',Today_,StartDate) gt 0>red<cfelse>blue</cfif>;">#Employee_Name# #Employee_Surname#</font></a></td>
				</tr>
				<tr>
                    <td>#NEW_CAT_NAME#</td>
					<td nowrap="nowrap">#DateFormat(DateAdd('h',session.ep.time_zone,StartDate),dateformat_style)#(#timeformat(date_add('h',session.ep.time_zone,StartDate),timeformat_style)#) - #DateFormat(DateAdd('h',session.ep.time_zone,FinishDate),dateformat_style)#(#timeformat(date_add('h',session.ep.time_zone,FinishDate),timeformat_style)#)</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td style="text-align:left;"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
