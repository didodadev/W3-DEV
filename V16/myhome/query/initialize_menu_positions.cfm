<cfif not isdefined("attributes.ini_employee_id") and isdefined(session.ep.userid)>
	<cfset attributes.ini_employee_id = session.ep.userid>
</cfif>

<cfset columnLeftList = "homebox_pay_claim,homebox_video,homebox_announcement,homebox_notes,homebox_poll_now,homebox_pdks">
<cfset columnCenterList = "homebox_main_news,homebox_myworks,homebox_correspondence,homebox_internaldemand,homebox_career,homebox_pot_cons,homebox_pot_partner,homebox_hr,homebox_finished_test_times,homebox_finished_contract,homebox_orders_come,homebox_offer_given,homebox_sell_today,homebox_promo_head,homebox_most_sell_stock,homebox_offer_to_give,homebox_new_stocks,homebox_orders_give,homebox_offer_taken,homebox_come_again_sip,homebox_purchase_today,homebox_more_stocks,homebox_send_order,homebox_offer_to_take,homebox_new_product,homebox_campaign_now,homebox_pre_invoice,homebox_service_head,homebox_call_center_application,homebox_call_center_interaction,homebox_spare_part,homebox_product_orders,homebox_pay,homebox_now_claim,homebox_old_contracts,homebox_forum,homebox_employee_profile,homebox_branch_profile">
<cfset columnRightList = "homebox_day_agenda,homebox_hr_agenda,homebox_hr_in_out,homebox_birthdate,homebox_attending_workers,homebox_employee_permittion,homebox_markets,homebox_is_permittion,homebox_widget,homebox_social_media">

<cfset openPanels = ListToArray("homebox_main_news")>

<cfset panels = ArrayNew(2)>

<cfset panels[1] = ArrayNew(1)>
<cfset panels[1] = ListToArray(columnLeftList)>

<cfset panels[2] = ArrayNew(1)>
<cfset panels[2] = ListToArray(columnCenterList)>

<cfset panels[3] = ArrayNew(1)>
<cfset panels[3] = ListToArray(columnRightList)>

<cfquery name="FIRST_VIEW_OF_PANEL" datasource="#DSN#">
	SELECT 
        PANEL_NAME, 
        COLUMN_INDEX, 
        SEQUENCE_INDEX, 
        EMP_ID, 
        IS_WIDGET, 
        URL, 
        IS_CLOSE 
    FROM 
    	MY_SETTINGS_POSITIONS 
    WHERE 
	    EMP_ID = #attributes.ini_employee_id# 
    AND 
    	(IS_WIDGET=0 OR IS_WIDGET=NULL)
</cfquery>
<cfif FIRST_VIEW_OF_PANEL.recordcount eq 0>
	<cfquery datasource="#DSN#">
		<cfloop index="columnPosition" from="1" to="#ArrayLen(panels)#">		
			<cfloop index="sequencePosition" from="1" to="#ArrayLen(panels[columnPosition])#">
				<cfset sequencePositionIndex = sequencePosition - 1>
				<cfset isColose = 0>
				<cfif columnPosition eq 2>
					<cfset isColose =1>
				</cfif>
				
				<!--- Eğer Açık Paneller Arasındaysa --->
				<cfset isOpen = false>
				<cfloop index="panel" from="1" to="#ArrayLen(openPanels)#">
					<cfif panels[columnPosition][sequencePosition] is "homebox_main_news">
						<cfset isOpen = true>
						<cfbreak>
					</cfif>
				</cfloop>
					INSERT INTO MY_SETTINGS_POSITIONS 
						(PANEL_NAME,COLUMN_INDEX,SEQUENCE_INDEX,EMP_ID,IS_CLOSE) 
					VALUES
						('#panels[columnPosition][sequencePosition]#',#columnPosition#,#sequencePositionIndex#,#attributes.ini_employee_id#,<cfif isOpen>0<cfelse>#isColose#</cfif>)
			</cfloop>	
		</cfloop>
	</cfquery>
</cfif>
