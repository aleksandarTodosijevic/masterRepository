
CREATE VIEW [dbo].[Currency]
AS 
SELECT	
	 d.CurrencyKey
	,d.SourceCurrencyId
	,d.CurrencyCode as [Currency Code]
	,d.CurrencyDescription as [Currency Description]
	,CASE
		WHEN d.CurrencyCode = 'USD' THEN N'\$#,0.00;(\$#,0.00);\$#,0.00' --
		WHEN d.CurrencyCode = 'EUR' THEN N'\€#,0.00;(\€#,0.00);\€#,0.00' --
		WHEN d.CurrencyCode = 'GBP' THEN N'\£#,0.00;(\£#,0.00);\£#,0.00' --
		WHEN d.CurrencyCode = 'JPY' THEN N'\¥#,0.00;(\¥#,0.00);\¥#,0.00' --
		WHEN d.CurrencyCode = 'CAD' THEN N'\$#,0.00;(\$#,0.00);\$#,0.00' --
		WHEN d.CurrencyCode = 'CHF' THEN N'\Fr#,0.00;(\Fr#,0.00);\Fr#,0.00' --
		WHEN d.CurrencyCode = 'AUD' THEN N'\$#,0.00;(\$#,0.00);\$#,0.00' --
		WHEN d.CurrencyCode = 'ATS' THEN N'\ö\S#,0.00;(\ö\S#,0.00);\ö\S#,0.00' --
		WHEN d.CurrencyCode = 'BRE' THEN N'\R$#,0.00;(\R$#,0.00);\R$#,0.00'--
		WHEN d.CurrencyCode = 'CNY' THEN N'\¥#,0.00;(\¥#,0.00);\¥#,0.00' --
		WHEN d.CurrencyCode = 'DKK' THEN N'\kr#,0.00;(\kr#,0.00);\kr#,0.00' --
		WHEN d.CurrencyCode = 'FRF' THEN N'\₣#,0.00;(\₣#,0.00);\₣#,0.00' --
		WHEN d.CurrencyCode = 'DEM' THEN N'\D\M#,0.00;(\D\M#,0.00);\D\M#,0.00' --
		WHEN d.CurrencyCode = 'HKD' THEN N'\HK$#,0.00;(\HK$#,0.00);\HK$#,0.00' --
		WHEN d.CurrencyCode = 'INR' THEN N'\R\s#,0.00;(\R\s#,0.00);\R\s#,0.00' --
		WHEN d.CurrencyCode = 'IDR' THEN N'\Rp#,0.00;(\Rp#,0.00);\Rp#,0.00' --
		WHEN d.CurrencyCode = 'IEP' THEN N'\£#,0.00;(\£#,0.00);\£#,0.00' --
		WHEN d.CurrencyCode = 'KRW' THEN N'\₩#,0.00;(\₩#,0.00);\₩#,0.00' --
		WHEN d.CurrencyCode = 'MYR' THEN N'\R\M#,0.00;(\R\M#,0.00);\R\M#,0.00' --
		WHEN d.CurrencyCode = 'MUR' THEN N'\R\s#,0.00;(\R\s#,0.00);\R\s#,0.00' --
		WHEN d.CurrencyCode = 'MXP' THEN N'\M\e\x\$#,0.00;(\M\e\x\$#,0.00);\M\e\x\$#,0.00' --
		WHEN d.CurrencyCode = 'NZD' THEN N'\$#,0.00;(\$#,0.00);\$#,0.00' --
		WHEN d.CurrencyCode = 'NOK' THEN N'\kr#,0.00;(\kr#,0.00);\kr#,0.00' --
		WHEN d.CurrencyCode = 'SGD' THEN N'\S$#,0.00;(\S$#,0.00);\S$#,0.00' --
		WHEN d.CurrencyCode = 'ZAR' THEN N'\R#,0.00;(\R#,0.00);\R#,0.00' --
		WHEN d.CurrencyCode = 'ESP' THEN N'\Pta#,0.00;(\Pta#,0.00);\Pta#,0.00' --
		WHEN d.CurrencyCode = 'SEK' THEN N'\kr#,0.00;(\kr#,0.00);\kr#,0.00' --
		WHEN d.CurrencyCode = 'TWD' THEN N'\NT$#,0.00;(\NT$#,0.00);\NT$#,0.00' --
		WHEN d.CurrencyCode = 'THB' THEN N'\฿#,0.00;(\฿#,0.00);\฿#,0.00' --
		WHEN d.CurrencyCode = 'AED' THEN N'\د\.\إ#,0.00;(\د\.\إ#,0.00);\د\.\إ#,0.00'
		WHEN d.CurrencyCode = 'ZWD' THEN N'\Z$#,0.00;(\Z$#,0.00);\Z$#,0.00' --
		WHEN d.CurrencyCode = 'PHP' THEN N'\₱#,0.00;(\₱#,0.00);\₱#,0.00' --
		WHEN d.CurrencyCode = 'NLG' THEN N'\ƒ#,0.00;(\ƒ#,0.00);\ƒ#,0.00' --
		WHEN d.CurrencyCode = 'ECU' THEN N'\₠#,0.00;(\₠#,0.00);\₠#,0.00' --
	ELSE N' #,0.00;( #,0.00); #,0.00' END AS [Format String]
FROM dbo.DimCurrency d
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Currency] TO [DataServices]
    AS [dbo];

