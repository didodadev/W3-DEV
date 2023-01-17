<cfif len(attributes.member_type)>
	<cfif attributes.member_type eq 0>
		<cfset TYPE= 'calisan' >
	<cfelseif attributes.member_type eq 1>
		<cfset TYPE= 'partner' >
	<cfelseif attributes.member_type eq 2>
		<cfset TYPE= 'consumer' >
	</cfif>
</cfif>
<cfquery name="get_class_trainers" datasource="#dsn#">
	SELECT DISTINCT
		TCT.EMP_ID AS ID,
		0 AS MEMB_ID,
		0 AS COMP_ID,
		EMPLOYEE_NAME AS NAME,
		EMPLOYEE_SURNAME AS SURNAME,
		'' AS NICKNAME,
		'calisan' AS TIP		
	FROM	
		TRAINING_CLASS TC 
        INNER JOIN TRAINING_CLASS_TRAINERS TCT ON TC.CLASS_ID = TCT.CLASS_ID,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = TCT.EMP_ID
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(		
		EMPLOYEE_SURNAME  LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		OR
		EMPLOYEE_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
		AND TCT.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID = #attributes.train_id#)
	</cfif>
    <cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
		AND TC.TRAINING_CAT_ID = #attributes.training_cat_id#
	</cfif>
	<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
		AND TCT.TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
	<cfif len(attributes.member_type)>
		AND 'calisan' = '#TYPE#'
	</cfif>
	UNION
		SELECT DISTINCT 
			TCT.PAR_ID AS ID,
			COMPANY_PARTNER.PARTNER_ID AS MEMB_ID,
			COMPANY.COMPANY_ID AS COMP_ID,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SURNAME,
			COMPANY.NICKNAME AS NICKNAME,
			'partner' AS TIP		
		FROM
			TRAINING_CLASS TC 
            INNER JOIN TRAINING_CLASS_TRAINERS TCT ON TC.CLASS_ID = TCT.CLASS_ID,
			COMPANY_PARTNER,
			COMPANY
		WHERE
			COMPANY_PARTNER.PARTNER_ID = TCT.PAR_ID AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME  LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
			COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
			AND TCT.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID = #attributes.train_id#)
		</cfif>
		<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
			AND TCT.TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
			AND TC.TRAINING_CAT_ID = #attributes.training_cat_id#
		</cfif>
		<cfif len(attributes.member_type)>
			AND 'partner' = '#TYPE#'
		</cfif>
	UNION
		SELECT DISTINCT 
			TCT.CONS_ID AS ID,
			0 AS MEMB_ID,
			0 AS COMP_ID,
			CONSUMER.CONSUMER_NAME AS NAME,
			CONSUMER.CONSUMER_SURNAME AS SURNAME,
			'' AS NICKNAME,
			'consumer' AS TIP		
		FROM
			TRAINING_CLASS TC LEFT JOIN TRAINING_CLASS_TRAINERS TCT ON TC.CLASS_ID = TCT.CLASS_ID,
			CONSUMER
		WHERE
			CONSUMER.CONSUMER_ID = TCT.CONS_ID
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				CONSUMER.CONSUMER_SURNAME  LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				OR
				CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				)
			</cfif>
			<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
				AND TCT.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID = #attributes.train_id#)
			</cfif>
			<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
				AND TCT.TRAINING_SEC_ID = #attributes.training_sec_id#
			</cfif>
			<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
				AND TC.TRAINING_CAT_ID = #attributes.training_cat_id#
			</cfif>
			<cfif len(attributes.member_type)>
				AND 'consumer' = '#TYPE#'
			</cfif>
	UNION
		SELECT DISTINCT
			TRAINING_TRAINER.EMPLOYEE_ID AS ID,
			0 AS MEMB_ID,
			0 AS COMP_ID,
			EMPLOYEE_NAME AS NAME,
			EMPLOYEE_SURNAME AS SURNAME,
			'' AS NICKNAME,
			'calisan' AS TIP		
		FROM	
			TRAINING_TRAINER,
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_ID = TRAINING_TRAINER.EMPLOYEE_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			EMPLOYEE_SURNAME  LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
			EMPLOYEE_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
			AND TRAINING_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
			AND TRAINING_TRAINER.TRAINING_CAT_ID = #attributes.training_cat_id#
		</cfif>
		<cfif len(attributes.member_type)>
			AND 'calisan' = '#TYPE#'
		</cfif>
	UNION
		SELECT DISTINCT 
			TRAINING_TRAINER.PARTNER_COMPANY_ID AS ID,
			COMPANY_PARTNER.PARTNER_ID AS MEMB_ID,
			COMPANY.COMPANY_ID AS COMP_ID,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SURNAME,
			COMPANY.NICKNAME AS NICKNAME,
			'partner' AS TIP		
		FROM
			TRAINING_TRAINER,
			COMPANY_PARTNER,
			COMPANY
		WHERE
			COMPANY_PARTNER.COMPANY_ID = TRAINING_TRAINER.PARTNER_COMPANY_ID AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME  LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
			COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
			AND TRAINING_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
			AND TRAINING_TRAINER.TRAINING_CAT_ID = #attributes.training_cat_id#
		</cfif>
		<cfif len(attributes.member_type)>
			AND 'partner' = '#TYPE#'
		</cfif>
	UNION
		SELECT DISTINCT 
			TRAINING_TRAINER.CONSUMER_ID AS ID,
			CONSUMER.CONSUMER_ID AS MEMB_ID,
			0 AS COMP_ID,
			CONSUMER.CONSUMER_NAME AS NAME,
			CONSUMER.CONSUMER_SURNAME AS SURNAME,
			'' AS NICKNAME,
			'consumer' AS TIP		
		FROM
			TRAINING_TRAINER,
			CONSUMER
		WHERE
			CONSUMER.CONSUMER_ID = TRAINING_TRAINER.CONSUMER_ID
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				CONSUMER.CONSUMER_SURNAME  LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				OR
				CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				)
			</cfif>
			<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
				AND TRAINING_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id#
			</cfif>
			<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
				AND TRAINING_TRAINER.TRAINING_CAT_ID = #attributes.training_cat_id#
			</cfif>
			<cfif len(attributes.member_type)>
				AND 'consumer' = '#TYPE#'
			</cfif>
		ORDER BY 
			NAME,ID
</cfquery>
<!--- Eğitimci birden fazla eklenecek şekilde düzenleme yapıldığı icin query degistirildi SG20130319--->
<!--- <cfquery name="get_class_trainers" datasource="#dsn#">
	SELECT DISTINCT
		TRAINING_CLASS.TRAINER_EMP AS ID,
		0 AS MEMB_ID,
		0 AS COMP_ID,
		EMPLOYEE_NAME AS NAME,
		EMPLOYEE_SURNAME AS SURNAME,
		'' AS NICKNAME,
		'calisan' AS TIP		
	FROM	
		TRAINING_CLASS,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = TRAINING_CLASS.TRAINER_EMP
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(		
		EMPLOYEE_SURNAME  LIKE '%#attributes.keyword#%'
		OR
		EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
		AND TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID = #attributes.train_id#)
	</cfif>
	<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
		AND TRAINING_CLASS.TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
	<cfif len(attributes.member_type)>
		AND 'calisan' = '#TYPE#'
	</cfif>
UNION
	SELECT DISTINCT 
		TRAINING_CLASS.TRAINER_PAR AS ID,
		COMPANY_PARTNER.PARTNER_ID AS MEMB_ID,
		COMPANY.COMPANY_ID AS COMP_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SURNAME,
		COMPANY.NICKNAME AS NICKNAME,
		'partner' AS TIP		
	FROM
		TRAINING_CLASS,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS.TRAINER_PAR AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME  LIKE '%#attributes.keyword#%'
		OR
		COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
		AND TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID = #attributes.train_id#)
	</cfif>
	<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
		AND TRAINING_CLASS.TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
	<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
		AND TRAINING_CLASS.TRAINING_CAT_ID = #attributes.training_cat_id#
	</cfif>
	<cfif len(attributes.member_type)>
		AND 'partner' = '#TYPE#'
	</cfif>
UNION
	SELECT DISTINCT 
		TRAINING_CLASS.TRAINER_CONS AS ID,
		0 AS MEMB_ID,
		0 AS COMP_ID,
		CONSUMER.CONSUMER_NAME AS NAME,
		CONSUMER.CONSUMER_SURNAME AS SURNAME,
		'' AS NICKNAME,
		'consumer' AS TIP		
	FROM
		TRAINING_CLASS,
		CONSUMER
	WHERE
		CONSUMER.CONSUMER_ID = TRAINING_CLASS.TRAINER_CONS
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			CONSUMER.CONSUMER_SURNAME  LIKE '%#attributes.keyword#%'
			OR
			CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
			AND TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID = #attributes.train_id#)
		</cfif>
		<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
			AND TRAINING_CLASS.TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
			AND TRAINING_CLASS.TRAINING_CAT_ID = #attributes.training_cat_id#
		</cfif>
		<cfif len(attributes.member_type)>
			AND 'consumer' = '#TYPE#'
		</cfif>
	UNION
		SELECT DISTINCT
			TRAINING_TRAINER.EMPLOYEE_ID AS ID,
			0 AS MEMB_ID,
			0 AS COMP_ID,
			EMPLOYEE_NAME AS NAME,
			EMPLOYEE_SURNAME AS SURNAME,
			'' AS NICKNAME,
			'calisan' AS TIP		
		FROM	
			TRAINING_TRAINER,
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_ID = TRAINING_TRAINER.EMPLOYEE_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			EMPLOYEE_SURNAME  LIKE '%#attributes.keyword#%'
			OR
			EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
			AND TRAINING_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
			AND TRAINING_TRAINER.TRAINING_CAT_ID = #attributes.training_cat_id#
		</cfif>
		<cfif len(attributes.member_type)>
			AND 'calisan' = '#TYPE#'
		</cfif>
UNION
	SELECT DISTINCT 
		TRAINING_TRAINER.PARTNER_COMPANY_ID AS ID,
		COMPANY_PARTNER.PARTNER_ID AS MEMB_ID,
		COMPANY.COMPANY_ID AS COMP_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SURNAME,
		COMPANY.NICKNAME AS NICKNAME,
		'partner' AS TIP		
	FROM
		TRAINING_TRAINER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		COMPANY_PARTNER.COMPANY_ID = TRAINING_TRAINER.PARTNER_COMPANY_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME  LIKE '%#attributes.keyword#%'
		OR
		COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
		AND TRAINING_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
	<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
		AND TRAINING_TRAINER.TRAINING_CAT_ID = #attributes.training_cat_id#
	</cfif>
	<cfif len(attributes.member_type)>
		AND 'partner' = '#TYPE#'
	</cfif>
	UNION
		SELECT DISTINCT 
			TRAINING_TRAINER.CONSUMER_ID AS ID,
			CONSUMER.CONSUMER_ID AS MEMB_ID,
			0 AS COMP_ID,
			CONSUMER.CONSUMER_NAME AS NAME,
			CONSUMER.CONSUMER_SURNAME AS SURNAME,
			'' AS NICKNAME,
			'consumer' AS TIP		
		FROM
			TRAINING_TRAINER,
			CONSUMER
		WHERE
			CONSUMER.CONSUMER_ID = TRAINING_TRAINER.CONSUMER_ID
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				CONSUMER.CONSUMER_SURNAME  LIKE '%#attributes.keyword#%'
				OR
				CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%'
				)
			</cfif>
			<cfif isdefined('attributes.training_sec_id') and len(attributes.training_sec_id)>
				AND TRAINING_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id#
			</cfif>
			<cfif isdefined('attributes.training_cat_id') and len(attributes.training_cat_id)>
				AND TRAINING_TRAINER.TRAINING_CAT_ID = #attributes.training_cat_id#
			</cfif>
			<cfif len(attributes.member_type)>
				AND 'consumer' = '#TYPE#'
			</cfif>
		UNION
			SELECT DISTINCT 
				TRAINING_CLASS_TRAINER.GRP_ID AS ID,
				0 AS MEMB_ID,
				0 AS COMP_ID,
				USERS.GROUP_NAME AS NAME,
				'' AS SURNAME,
				'' AS NICKNAME,		
				'group' AS TIP
			FROM
				TRAINING_CLASS_TRAINER,<!---bu tabloya kayıt atan yer bulunmuyor. SG 20130319 --->
				USERS
			WHERE
				USERS.GROUP_ID = TRAINING_CLASS_TRAINER.GRP_ID AND
				TRAINING_CLASS_TRAINER.GRP_ID IS NOT NULL
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND USERS.GROUP_NAME  LIKE '%#attributes.keyword#%'
			</cfif>				
	ORDER BY NAME,ID
</cfquery> --->
