<cfquery name="GET_BRANCH_TRANSFER" datasource="#DSN#">
	SELECT
		BTD.TABLE_NAME, 
		B.BRANCH_ID,
		B.BRANCH_NAME,
		CBDK.BOYUT_KODU
	FROM 
		BRANCH_TRANSFER_DEFINITION BTD,
		BRANCH B,
		COMPANY_BOYUT_DEPO_KOD CBDK
	WHERE
		BTD.BRANCH_ID = #url.transfer_branch_id# AND
		BTD.BRANCH_ID = B.BRANCH_ID AND
		CBDK.W_KODU = B.BRANCH_ID
</cfquery>
<cfif get_branch_transfer.recordcount>
	<cfquery name="UPD_TRANSFER" datasource="mushizgun">
		UPDATE 
			#get_branch_transfer.table_name# 
		SET 
			CARITIP = 'K',
			EMAIL = CARITIP
		WHERE 
			KAYITNO = #url.kayitno#
	</cfquery>	
</cfif>
<cflocation url="#request.self#?fuseaction=crm.list_branch_transfer&branch_state=#get_branch_transfer.branch_id#,#get_branch_transfer.table_name#&form_submitted=1" addtoken="No">
