CREATE DATABASE TechStore;

use TechStore;

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(100)
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE NOT NULL,
    estado VARCHAR(20) NOT NULL,
    total_pedido DECIMAL(10, 2) NOT NULL CHECK (total_pedido >= 0),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);


CREATE TABLE DetallePedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Proveedor (
    id_proveedor INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(100)
);

CREATE TABLE Inventario (
    id_registro INT PRIMARY KEY,
    id_producto INT,
    tipo_registro ENUM('entrada', 'salida') NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    fecha_registro DATE NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

INSERT INTO Cliente (id_cliente, nombre, telefono, direccion) VALUES
(6, 'Pedro Gomez', '3213213210', 'Calle 6'),
(7, 'Laura Fernandez', '1231231230', 'Calle 7'),
(8, 'Daniela Martinez', '3211231234', 'Calle 8'),
(9, 'Andres Ruiz', '4564564560', 'Calle 9'),
(10, 'Sofia Vargas', '7897897890', 'Calle 10');


INSERT INTO Producto (id_producto, nombre, categoria, stock, precio) VALUES
(1, 'Producto A', 'Categoria 1', 100, 50.00),
(2, 'Producto B', 'Categoria 1', 200, 30.00),
(3, 'Producto C', 'Categoria 2', 150, 20.00),
(4, 'Producto D', 'Categoria 2', 300, 25.00),
(5, 'Producto E', 'Categoria 3', 50, 100.00),
(6, 'Producto F', 'Categoria 3', 60, 45.00),
(7, 'Producto G', 'Categoria 1', 90, 75.00),
(8, 'Producto H', 'Categoria 2', 120, 35.00),
(9, 'Producto I', 'Categoria 3', 110, 55.00),
(10, 'Producto J', 'Categoria 2', 140, 65.00);

INSERT INTO Pedido (id_pedido, id_cliente, fecha_pedido, estado, total_pedido) VALUES
(6, 6, '2024-06-15', 'Pendiente', 400.00),
(7, 7, '2024-07-20', 'Completado', 250.00),
(8, 8, '2024-08-10', 'Completado', 350.00),
(9, 9, '2024-09-25', 'Pendiente', 225.00),
(10, 10, '2024-10-05', 'Completado', 600.00);

INSERT INTO DetallePedido (id_pedido, id_producto, cantidad) VALUES
(6, 6, 8),
(6, 7, 4),
(7, 8, 6),
(7, 9, 2),
(8, 6, 5),
(8, 10, 1),
(9, 7, 3),
(9, 8, 6),
(10, 9, 7),
(10, 10, 2);

INSERT INTO Proveedor (id_proveedor, nombre, telefono, correo) VALUES
(6, 'Proveedor F', '5554443332', 'proveedorf@gmail.com'),
(7, 'Proveedor G', '5552221110', 'proveedorg@gmail.com'),
(8, 'Proveedor H', '5550009998', 'proveedorh@gmail.com'),
(9, 'Proveedor I', '5558887776', 'proveedori@gmail.com'),
(10, 'Proveedor J', '5556665554', 'proveedorj@gmail.com');

-- Insertar registros en la tabla Inventario
INSERT INTO Inventario (id_registro, id_producto, tipo_registro, cantidad, fecha_registro) VALUES
(1, 1, 'entrada', 100, '2024-01-01'),
(2, 2, 'entrada', 200, '2024-01-01'),
(3, 3, 'entrada', 150, '2024-01-01'),
(4, 4, 'entrada', 300, '2024-01-01'),
(5, 5, 'entrada', 50, '2024-01-01'),
(6, 1, 'salida', 5, '2024-01-15'),
(7, 2, 'salida', 3, '2024-01-15'),
(8, 3, 'salida', 7, '2024-02-20'),
(9, 4, 'salida', 2, '2024-02-20'),
(10, 1, 'salida', 10, '2024-03-10'),
(11, 6, 'entrada', 60, '2024-06-01'),
(12, 7, 'entrada', 90, '2024-06-01'),
(13, 8, 'entrada', 120, '2024-06-01'),
(14, 9, 'entrada', 110, '2024-06-01'),
(15, 10, 'entrada', 140, '2024-06-01');

-- Cantidad de pedidos mensuales
SELECT 
    YEAR(p.fecha_pedido) AS año,
    MONTH(p.fecha_pedido) AS mes,
    COUNT(p.id_pedido) AS cantidad_pedidos
FROM Pedido p
GROUP BY YEAR(p.fecha_pedido), MONTH(p.fecha_pedido)
ORDER BY anio, mes;

-- Cantidad mensual pedida de cada artículo
SELECT 
    YEAR(p.fecha_pedido) AS año,
    MONTH(p.fecha_pedido) AS mes,
    pr.nombre AS articulo,
    SUM(dp.cantidad) AS cantidad
FROM Pedido p
INNER JOIN DetallePedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN Producto pr ON dp.id_producto = pr.id_producto
GROUP BY YEAR(p.fecha_pedido), MONTH(p.fecha_pedido), pr.nombre
ORDER BY año, mes, articulo;

-- Ranking de artículos 
SELECT 
    pr.nombre AS articulo,
    YEAR(p.fecha_pedido) AS año,
    MONTH(p.fecha_pedido) AS mes,
    SUM(dp.cantidad) AS cantidad_pedida
FROM Pedido p
INNER JOIN DetallePedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN Producto pr ON dp.id_producto = pr.id_producto
GROUP BY pr.nombre, YEAR(p.fecha_pedido), MONTH(p.fecha_pedido)
ORDER BY cantidad_pedida DESC, año, mes, articulo;


-- Clientes con más pedidos realizados
SELECT 
    c.nombre AS cliente,
    COUNT(p.id_pedido) AS cantidad_pedidos
FROM Cliente c
INNER JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY cantidad_pedidos DESC;

-- Ingreso mensual total por ventas
SELECT 
    YEAR(p.fecha_pedido) AS anio,
    MONTH(p.fecha_pedido) AS mes,
    SUM(p.total_pedido) AS ingreso_total
FROM Pedido p
GROUP BY YEAR(p.fecha_pedido), MONTH(p.fecha_pedido)
ORDER BY anio, mes;

-- Productos con stock bajo (menos de 10 unidades)
SELECT 
    nombre AS producto,
    stock
FROM Producto
WHERE stock < 10;

-- Pedidos pendientes de entrega
SELECT 
    p.id_pedido AS pedido,
    c.nombre AS cliente,
    p.fecha_pedido AS fecha_pedido
FROM Pedido p
INNER JOIN Cliente c ON p.id_cliente = c.id_cliente
WHERE p.estado = 'pendiente';
-- Productos más vendidos por categoría
SELECT 
    pr.categoria AS categoria,
    pr.nombre AS producto,
    SUM(dp.cantidad) AS cantidad_vendida
FROM DetallePedido dp
INNER JOIN Producto pr ON dp.id_producto = pr.id_producto
GROUP BY pr.categoria, pr.nombre
ORDER BY pr.categoria, cantidad_vendida DESC;

-- Proveedores con más productos suministrados
SELECT 
    pr.nombre AS proveedor,
    COUNT(p.id_producto) AS cantidad_productos_suministrados
FROM Proveedor pr
INNER JOIN Producto p ON pr.id_proveedor = id_proveedor
GROUP BY id_proveedor, pr.nombre
ORDER BY cantidad_productos_suministrados DESC;
-- Historial de compras de un cliente específico, ordenada desde la más reciente a la más antigua
SELECT 
    p.id_pedido AS pedido,
    p.fecha_pedido AS fecha_pedido,
    p.estado AS estado_pedido,
    p.total_pedido AS total_pedido
FROM Pedido p
WHERE p.id_cliente = 1
ORDER BY p.fecha_pedido DESC;
