<!-- Description : ProductOurCompany tablosuna index eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Product-->
<querytag>
CREATE NONCLUSTERED INDEX [NCL_PRODUCT_ID]
ON [PRODUCT_OUR_COMPANY] ([OUR_COMPANY_ID])
INCLUDE ([PRODUCT_ID])
CREATE NONCLUSTERED INDEX [NCL_PRODUCT_COMPANY_ID]
ON [PRODUCT_OUR_COMPANY] ([PRODUCT_ID],[OUR_COMPANY_ID])
</querytag>