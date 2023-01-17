<!-- Description : Retail Product Function
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
   CREATE FUNCTION [fnc_get_rival_avg]
        (
        @product_id int
        )
        RETURNS float
        AS
        BEGIN
        DECLARE @Result float
        SET @Result =   (
                SELECT
                        AVG(P) AS PRICE
                FROM
                        (
                            SELECT 
                                ISNULL(PRICE_RIVAL.PRICE,0) + ISNULL(PRICE_RIVAL.PRICE_2,0) AS P
                            FROM 
                                PRICE_RIVAL 
                            WHERE
                                PRICE_RIVAL.PRODUCT_ID = @product_id AND 
                                PRICE_RIVAL.STARTDATE <= GETDATE() AND PRICE_RIVAL.FINISHDATE >= GETDATE()
                    ) AS RAKIP_FIYATLAR
            )
        RETURN(@Result)
        END
</querytag>
