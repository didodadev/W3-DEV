<cfquery name="get_card" datasource="#new_dsn2#">
	SELECT
		ACTION_ID,
		BILL_NO,
		PAPER_NO,
		CARD_TYPE,  
		ACTION_TYPE,
		CARD_CAT_ID 
	FROM
		ACCOUNT_CARD
	WHERE
		CARD_ID IN(#attributes.CARD_ID#)
</cfquery>
<cfoutput query="get_card">
	<cfswitch expression="#get_card.ACTION_TYPE#">
		<cfcase value="130">
			<cfif isdefined("attributes.is_virtual_puantaj")>
				<cfquery name="upd_puantaj" datasource="#new_dsn2#">
					UPDATE
						#dsn_alias#.EMPLOYEES_PUANTAJ_VIRTUAL
					SET 
						IS_ACCOUNT=0
					WHERE
						PUANTAJ_ID=#get_card.ACTION_ID#
				</cfquery>
			<cfelse>
				<cfquery name="upd_puantaj" datasource="#new_dsn2#">
					UPDATE
						#dsn_alias#.EMPLOYEES_PUANTAJ
					SET 
						IS_ACCOUNT=0
					WHERE
						PUANTAJ_ID=#get_card.ACTION_ID#
				</cfquery>
			</cfif>
		</cfcase>
		<cfcase value="21,22,23,24,25,27,31,32,33,34,35,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67">
			<cfif  find(get_card.ACTION_TYPE,"21,22,23")>
				<cfquery name="upd_puantaj" datasource="#new_dsn2#">
					UPDATE
						BANK_ACTIONS
					SET 
						IS_ACCOUNT=0
					WHERE
						ACTION_ID=#get_card.ACTION_ID#
				</cfquery>
			</cfif>
			<cfif not find(get_card.ACTION_TYPE,"23,24,25,27")>
				<cfquery name="upd_puantaj" datasource="#new_dsn2#">
					UPDATE
						CASH_ACTIONS
					SET 
						IS_ACCOUNT=0
					WHERE
							ACTION_ID=#get_card.ACTION_ID#
						AND 
							ACTION_TYPE_ID=22
				</cfquery>
			</cfif>
			<cfif  find(get_card.ACTION_TYPE,"34,35,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67")>
				<cfquery name="UPD_INVOICE_PROCESS" datasource="#new_dsn2#">
					UPDATE
						 INVOICE 
					SET
						<cfif find(get_card.ACTION_TYPE,"34,35")>
							IS_ACCOUNTED=1
						<cfelse>
							IS_PROCESSED=0
						</cfif>
					WHERE 
						INVOICE_ID=#get_card.ACTION_ID#
				</cfquery>
			</cfif>
		</cfcase>
	</cfswitch>
	<cfif not find(get_card.ACTION_TYPE,"130,21,22,23") and len(get_card.ACTION_ID)>
		<cfquery name="upd_cari_rows" datasource="#new_dsn2#">
			UPDATE 
				CARI_ROWS 
			SET 
				IS_ACCOUNT=0,
				IS_ACCOUNT_TYPE=NULL
			WHERE 
				ACTION_ID=#get_card.ACTION_ID#
			AND
				ACTION_TYPE_ID=#get_card.ACTION_TYPE#
		</cfquery>
	</cfif>
</cfoutput>

