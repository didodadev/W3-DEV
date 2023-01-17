<!-- Description : Retail Product Function
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    CREATE FUNCTION [fnc_get_unit_multiplier]
        (
        @product_id int,
        @unit int
        )
        RETURNS float
        AS
        BEGIN
        DECLARE @Result float
        SET @Result =   (
                SELECT TOP 1
                        MULTIPLIER
                    FROM
                        PRODUCT_UNIT
                    WHERE
                        PRODUCT_ID = @product_id AND
                        UNIT_ID = @unit
            )
        RETURN(@Result)
        END
</querytag>
