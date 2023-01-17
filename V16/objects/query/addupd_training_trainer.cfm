<!--- Çalışanın Verdiği Eğitimler --->
<cfif attributes.rowCount gt 0>
<cfloop from="1" to="#attributes.rowCount#" index="i">
	<cfif isdefined('attributes.training_sec_id#i#') and len(evaluate('attributes.training_sec_id#i#')) and evaluate('attributes.training_sec_id#i#') gt 0>
		<cfif isdefined('attributes.rowkontrol#i#') and len(evaluate('attributes.rowkontrol#i#')) and evaluate('attributes.rowkontrol#i#') gt 0>
			<cfif isDefined('attributes.training_trainer_id#i#') and len(evaluate('attributes.training_trainer_id#i#'))>
				<cfquery name="UPD_TRAINING_TRAINER" datasource="#DSN#">
					UPDATE
						TRAINING_TRAINER
					SET
						TRAINING_SEC_ID = <cfif len(evaluate('attributes.training_sec_id#i#'))>#evaluate('attributes.training_sec_id#i#')#<cfelse>NULL</cfif>,
						TRAINING_CAT_ID = <cfif len(evaluate('attributes.training_cat_id#i#'))>#evaluate('attributes.training_cat_id#i#')#<cfelse>NULL</cfif>,
						TRAINING_COST = <cfif len(evaluate('attributes.training_cost#i#'))>#evaluate('attributes.training_cost#i#')#<cfelse>NULL</cfif>,
						TRAINING_COST_MONEY = <cfif len(evaluate('attributes.training_cost_money#i#'))>'#wrk_eval('attributes.training_cost_money#i#')#'<cfelse>NULL</cfif>,
						TRAINING_DETAIL = <cfif len(evaluate('attributes.training_detail#i#'))>'#Replace(evaluate('attributes.training_detail#i#'),"'"," ","all")#'<cfelse>NULL</cfif>,
						EMPLOYEE_ID = <cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						PARTNER_ID = <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
						PARTNER_COMPANY_ID = <cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						CONSUMER_ID = <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>
					WHERE
						TRAINING_TRAINER_ID = #evaluate("attributes.training_trainer_id#i#")#
				</cfquery>
			<cfelse>
				<cfquery name="ADD_TRAINING_TRAINER" datasource="#dsn#">
					INSERT INTO
						TRAINING_TRAINER
					(
						TRAINING_SEC_ID,
						TRAINING_CAT_ID,
						TRAINING_COST,
						TRAINING_COST_MONEY,
						TRAINING_DETAIL,
						EMPLOYEE_ID,
						PARTNER_ID,
						PARTNER_COMPANY_ID,
						CONSUMER_ID
					)
					VALUES
					(
						<cfif len(evaluate('attributes.training_sec_id#i#'))>#evaluate('attributes.training_sec_id#i#')#<cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.training_cat_id#i#'))>#evaluate('attributes.training_cat_id#i#')#<cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.training_cost#i#'))>#evaluate('attributes.training_cost#i#')#<cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.training_cost_money#i#'))>'#wrk_eval('attributes.training_cost_money#i#')#'<cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.training_detail#i#'))>'#Replace(evaluate('attributes.training_detail#i#'),"'"," ","all")#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>
					)
				</cfquery>
			</cfif>
		<cfelse>
			<cfif isDefined('attributes.training_trainer_id#i#') and len(evaluate('attributes.training_trainer_id#i#'))>
				<cfquery name="DEL_TRAINING_TRAINER" datasource="#dsn#">
					DELETE FROM
						TRAINING_TRAINER
					WHERE
						TRAINING_TRAINER_ID = #evaluate('attributes.training_trainer_id#i#')#
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfloop>
</cfif>
<!--- Çalışanın Verdiği Eğitimler --->
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>