<cfquery name="get_report_queries" datasource="#dsn#">
	SELECT
		REPORTS_QUERIES.*,
		REPORT.REPORT_NAME AS QUERY_NAME
	FROM
		REPORTS_QUERIES,
		REPORT
	WHERE
		REPORTS_QUERIES.REPORT_ID = #attributes.REPORT_ID#
		AND
		REPORT.REPORT_ID = REPORTS_QUERIES.QUERY_ID
</cfquery>
<cfscript>
	session.report = structNew();
	session.report.1 = structNew();
	session.report.1.query_id = arrayNew(1);
	session.report.1.query_name = arrayNew(1);
	session.report.1.report_type = arrayNew(1);
	session.report.2 = structNew();
	session.report.2.query_id = arrayNew(1);
	session.report.2.query_name = arrayNew(1);
	session.report.2.report_type = arrayNew(1);
	session.report.3 = structNew();
	session.report.3.query_id = arrayNew(1);
	session.report.3.query_name = arrayNew(1);
	session.report.3.report_type = arrayNew(1);
	counter1 = 0;
	counter2 = 0;
	counter3 = 0;
	for (i=1; i lte get_report_queries.recordcount; i = i+1)
		{
		column_no = get_report_queries.COLUMN_NO[i];
		if (get_report_queries.column_no[i] eq 1)
			{
			counter1 = counter1 + 1;
			session.report.1.query_id[counter1] = get_report_queries.query_id[i];
			session.report.1.query_name[counter1] = get_report_queries.query_name[i];
			session.report.1.report_type[counter1] = get_report_queries.display_type[i];
			}
		else if (get_report_queries.column_no[i] eq 2)
			{
			counter2 = counter2 + 1;
			session.report.2.query_id[counter2] = get_report_queries.query_id[i];
			session.report.2.query_name[counter2] = get_report_queries.query_name[i];
			session.report.2.report_type[counter2] = get_report_queries.display_type[i];
			}
		else if (get_report_queries.column_no[i] eq 3)
			{
			counter3 = counter3 + 1;
			session.report.3.query_id[counter3] = get_report_queries.query_id[i];
			session.report.3.query_name[counter3] = get_report_queries.query_name[i];
			session.report.3.report_type[counter3] = get_report_queries.display_type[i];
			}
		}
</cfscript>
