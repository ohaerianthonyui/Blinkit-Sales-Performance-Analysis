select * from blinkitdata;


-- jChanging the names of some rows
UPDATE blinkitdata
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;
	-- Checking if the changes were made
	Select * from blinkitdata
	where Item_Fat_Content IN ('LF',  'reg')


	--Finding the total sales
	SELECT CAST(SUM(Total_Sales)/100000 AS DECIMAL(10,2))  AS Total_Sale_Milions
	FROM blinkitdata 

	--Finding the average sales
	SELECT CAST(AVG(Total_Sales) AS DECIMAL (10,2)) AS Avg_Sales
	FROM blinkitdata

	--Finding the number of items ordered
	SELECT COUNT(*) AS No_of_orders
	From blinkitdata

	--Finding the average rating on the products
	SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
    FROM blinkitdata;

	--Finding the total sales by Fat Content

	SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM blinkitdata
	GROUP BY Item_Fat_Content


	-- Finding the Total Sales by Item Type
    SELECT Item_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkitdata
    GROUP BY Item_Type
    ORDER BY Total_Sales DESC


	--	Finding the fat content by outlet for Total Sales
	SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
	FROM 
	(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkitdata
    GROUP BY Outlet_Location_Type, Item_Fat_Content
	) AS SourceTable
	PIVOT 
	(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
	) AS PivotTable
	ORDER BY Outlet_Location_Type;

	--Finding the total sales by outlet establishment
	SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM blinkitdata
	GROUP BY Outlet_Establishment_Year
	ORDER BY Outlet_Establishment_Year

	--Finding the percentage of sales by outlet size
	SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
	FROM blinkitdata
	GROUP BY Outlet_Size
	ORDER BY Total_Sales DESC;

	--Finding the sales by outlet location
	
	SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM blinkitdata
	GROUP BY Outlet_Location_Type
	ORDER BY Total_Sales DESC

	--Finding all metrics by outlet type
	SELECT Outlet_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
	FROM blinkitdata
	GROUP BY Outlet_Type
	ORDER BY Total_Sales DESC
