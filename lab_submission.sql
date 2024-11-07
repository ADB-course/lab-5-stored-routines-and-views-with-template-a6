-- (i) A Procedure called PROC_LAB5
--This stored procedure retrieves the total order amount for a specified customer,
-- along with their payment details.
DELIMITER $$
CREATE PROCEDURE PROC_LAB5(IN customerNumber INT)
BEGIN
    SELECT
        customers.customerNumber,
        customers.customerName,
        SUM(orders.amount) AS totalOrderAmount,
        payments.paymentDate,
        payments.amount AS paymentAmount
    FROM 
        customers
    JOIN 
        orders ON customers.customerNumber = orders.customerNumber
    LEFT JOIN 
        payments ON customers.customerNumber = payments.customerNumber
    WHERE 
        customers.customerNumber = customerNumber
    GROUP BY 
        customers.customerNumber, payments.paymentDate;
END;
DELIMITER ;
-- (ii) A Function called FUNC_LAB5
--This function calculates the total payments made by a specific customer.
DELIMITER //
CREATE FUNCTION FUNC_LAB5(customerNumber INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_payment DECIMAL(10, 2);
    
    SELECT SUM(amount) INTO total_payment
    FROM payments
    WHERE customerNumber = customerNumber;
    
    RETURN IFNULL(total_payment, 0);
END //
DELIMITER ;
-- (iii) A View called VIEW_LAB5
--This view lists product details along with the total quantity ordered for each product, 
--processed into a summary format.
CREATE VIEW `VIEW_LAB5` AS
SELECT
    products.productCode AS 'Product Code',
    products.productName AS 'Product Name',
    productlines.productLine AS 'Product Line',
    SUM(orderdetails.quantityOrdered) AS 'Total Quantity Ordered'
FROM
    products
JOIN
    productlines ON products.productLine = productlines.productLine
JOIN
    orderdetails ON products.productCode = orderdetails.productCode
GROUP BY
    products.productCode, products.productName, productlines.productLine
ORDER BY
    `Total Quantity Ordered` DESC;

