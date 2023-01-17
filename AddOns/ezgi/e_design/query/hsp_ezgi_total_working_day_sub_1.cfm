<cfset working_amount = DateDiff('n',working_start,working_end)>
<cfset Temp = QueryAddRow(working_blocks)>
<cfset Temp = QuerySetCell(working_blocks, "id", working_id)>
<cfset Temp = QuerySetCell(working_blocks, "start_date", working_start)>
<cfset Temp = QuerySetCell(working_blocks, "end_date", working_end)>
<cfset Temp = QuerySetCell(working_blocks, "amount", working_amount)>