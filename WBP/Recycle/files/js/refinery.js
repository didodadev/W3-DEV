function companyAutoComplete(formName,fieldName,fieldId){
	AutoComplete_Create(fieldName,'MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1,2,3','COMPANY_ID',fieldId,formName,'3','250');
}
function employeeAutoComplete(formName,fieldName,fieldId){
	AutoComplete_Create(fieldName,'MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID',fieldId,formName,'3','135')
}