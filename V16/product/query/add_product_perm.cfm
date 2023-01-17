<cfquery name="add_pro_comp" datasource="#DSN3#" result="MAX_ID">
  INSERT INTO
    PRODUCT_COMP
	(
	  COMPETITIVE,
	  DETAIL
	)
	VALUES
	(
	  '#PRO_COMP#',
	  '#DETAIL#'
	)
</cfquery>
<cfquery name="ADD_PRO_COMP_PERM" datasource="#DSN3#">
  INSERT INTO 
    PRODUCT_COMP_PERM
	(
	  COMPETITIVE_ID,
	  PERMISSION_ID,
	  POSITION_CODE
	)
	VALUES
	(
	 #MAX_ID.IDENTITYCOL#,
	 <cfif PERMISSION_ID IS 1>
	  1,
	 <cfelseif PERMISSION_ID IS 2>
	 2,
	 <cfelseif PERMISSION_ID IS 3>
	 3,
	 <cfelseif PERMISSION_ID IS 4>
	 4,
	 <cfelseif PERMISSION_ID IS 5>
	 5,
	 </cfif>
	#position_code#
	)
</cfquery>
