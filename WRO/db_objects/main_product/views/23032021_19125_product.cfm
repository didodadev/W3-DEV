CREATE VIEW [@_dsn_product_@].[GET_STOCK_BARCODES_ALL] AS
	SELECT
		STOCKS.PRODUCT_ID,
		STOCKS_BARCODES.STOCK_ID,
		STOCKS_BARCODES.BARCODE
	FROM
		STOCKS_BARCODES,
		STOCKS
	WHERE
		STOCKS.STOCK_ID = STOCKS_BARCODES.STOCK_ID