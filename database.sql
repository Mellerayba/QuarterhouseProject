CREATE TABLE Drink_List (
	DrinkID INTEGER AUTO_INCREMENT PRIMARY KEY, 
	Drink_Name VARCHAR(30), 
	Drink_Type VARCHAR(30), 
	Bottle_Size INTEGER, 
	Drink_Serving_Size INTEGER
);
CREATE TABLE Users (
	UserID INTEGER AUTO_INCREMENT PRIMARY KEY,
	UserName VARCHAR(60)
	UserPassword VARCHAR(600)
);
ALTER TABLE Users ADD COLUMN 
UserPassword Varchar(600);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    TableID INT,
    OrderDateTime DATETIME,
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    FoodRecipeID INT,
    DrinkID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (FoodRecipeID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (DrinkID) REFERENCES Drink_List(DrinkID)
);

CREATE TABLE Managers (
	ManagerID INTEGER AUTO_INCREMENT PRIMARY KEY,
	UserName VARCHAR(60),
	UserPassword VARCHAR(600)
);


CREATE TABLE Messages (
    MessageID INT AUTO_INCREMENT PRIMARY KEY,
    ManagerID INT,
    Title VARCHAR(255),
    Body TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ManagerID) REFERENCES Managers(ManagerID)
);




CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
	Firstname VARCHAR(50),
    Surname VARCHAR(50)
);

CREATE TABLE Tables (
    TableID INT AUTO_INCREMENT PRIMARY KEY,
    TableNumber VARCHAR(10),
    Capacity INT
);

CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TableID INT,
    BookingDateTime DATETIME,
    Duration INT,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);


CREATE TABLE TableAvailability (
    AvailabilityID INT AUTO_INCREMENT PRIMARY KEY,
    TableID INT,
    Date DATE,
    TimeSlot VARCHAR(20),
    IsAvailable BOOLEAN,
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);




CREATE TABLE Drink_Stock(
	DrinkID INT, 
	Drink_Count INT, 
FOREIGN KEY (DrinkID) REFERENCES Drink_List(DrinkID)
);


CREATE TABLE Drink_Recipe(
	Drink_RecipeID INTEGER AUTO_INCREMENT PRIMARY KEY, 
	Drink_RecipeName VARCHAR(30),
	Drink_RecipeInstructions VARCHAR(500),
	Drink_RecipeGarnish VARCHAR(250)
);


 CREATE TABLE Drink_Recipe_Link
	(Recipe_Drink_LinkID INTEGER AUTO_INCREMENT PRIMARY KEY, 
	Drink_RecipeID INT,
	DrinkID INT,
	Drink_Ingredient_Quantity INT,
FOREIGN KEY(DrinkID) REFERENCES Drink_List(DrinkID), 
FOREIGN KEY(Drink_RecipeID) REFERENCES Drink_Recipe(Drink_RecipeID)
);


CREATE TABLE Food_List (
	FoodId INTEGER AUTO_INCREMENT PRIMARY KEY,
	Food_Name VARCHAR(50),
	Food_Type VARCHAR(50),
	Food_Expiratory DATE,
	Food_Serving_Size INT,
	Food_Base_Size INT
);

CREATE TABLE Wine_Price (
	DrinkID INT,
	Wine_Price_Type VARCHAR(7),
	Wine_Price INT,
FOREIGN KEY (DrinkID) REFERENCES Drink_List(DrinkID)
);

CREATE TABLE Food_Stock (
	FoodId INT,
	Food_Count INT,
	Food_Expiratory_Date DATE,
FOREIGN KEY (FoodId) REFERENCES Food_List(FoodId)
);

CREATE TABLE ManagerMessages (
    MessageID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Body TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE FoodIngredientUsage (
    UsageID INT AUTO_INCREMENT PRIMARY KEY,
    FoodIngredientID INT,
    UsageCount INT,
    FOREIGN KEY (FoodIngredientID) REFERENCES Food_List(FoodId)
);

CREATE TABLE DrinkIngredientUsage (
    UsageID INT AUTO_INCREMENT PRIMARY KEY,
    DrinkIngredientID INT,
    UsageCount INT,
    FOREIGN KEY (DrinkIngredientID) REFERENCES Drink_List(DrinkID)
);


CREATE TABLE Food_Recipe (
	Food_RecipeID INTEGER AUTO_INCREMENT PRIMARY KEY,
	Food_RecipeName VARCHAR(150),
	Food_RecipeTTC INT,
	Food_RecipeType VARCHAR(150),
	Food_RecipePrice INT
);


CREATE TABLE Food_Recipe_Link (
	Food_Recipe_LinkID INTEGER AUTO_INCREMENT PRIMARY KEY,
	FoodID INT,
	Food_RecipeID INT,
FOREIGN KEY (FoodID) REFERENCES Food_List(FoodID),
FOREIGN KEY (Food_RecipeID) REFERENCES Food_Recipe(Food_RecipeID)
);

ALTER TABLE Drink_List ADD COLUMN 
Drink_Price INT;
ALTER TABLE Drink_Recipe ADD COLUMN
Drink_Recipe_Price INT;

CREATE TABLE Drink_Reccomend (
	Drink_Reccomend INTEGER AUTO_INCREMENT PRIMARY KEY,
	Food_RecipeID INT,
	DrinkPair1ID INT,
    DrinkPair2ID INT,
    DrinkPair3ID INT,
    DrinkPair4ID INT,
	DrinkPair5ID Int,
	DrinkPair6ID INT,
	DrinkPair7ID INT,
	DrinkPair8ID Int,
	DrinkPair9ID INT,
    FOREIGN KEY (Food_RecipeID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (DrinkPair1ID) REFERENCES Drink_List(DrinkID),
    FOREIGN KEY (DrinkPair2ID) REFERENCES Drink_List(DrinkID),
    FOREIGN KEY (DrinkPair3ID) REFERENCES Drink_List(DrinkID),
    FOREIGN KEY (DrinkPair4ID) REFERENCES Drink_List(DrinkID),
	FOREIGN KEY (DrinkPair5ID) REFERENCES Drink_List(DrinkID),
    FOREIGN KEY (DrinkPair6ID) REFERENCES Drink_List(DrinkID),
	FOREIGN KEY (DrinkPair7ID) REFERENCES Drink_List(DrinkID),
	FOREIGN KEY (DrinkPair8ID) REFERENCES Drink_List(DrinkID),
    FOREIGN KEY (DrinkPair9ID) REFERENCES Drink_List(DrinkID)
);


CREATE TABLE Recipe_Recipe_Link (
 	Recipe_Recipe_LinkID INTEGER AUTO_INCREMENT PRIMARY KEY,
    Food_RecipeID INT,
    Pair1ID INT,
    Pair2ID INT,
    Pair3ID INT,
    Pair4ID INT,
	Pair5ID Int,
	Pair6ID INT,
    FOREIGN KEY (Food_RecipeID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (Pair1ID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (Pair2ID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (Pair3ID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (Pair4ID) REFERENCES Food_Recipe(Food_RecipeID),
	FOREIGN KEY (Pair5ID) REFERENCES Food_Recipe(Food_RecipeID),
    FOREIGN KEY (Pair6ID) REFERENCES Food_Recipe(Food_RecipeID)
);



INSERT INTO Drink_List (Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price) 
VALUES ("Helles","Beer",500,500,650),
("Chaff","Beer",500,500,650),
("Easy Sunshine","NA_Beer",500,500,595),
("Hoof","Stout",500,500,650),
("Tirril OF","Ale",500,500,650),
("Tirril DG","Stout",500,500,650),
("Black Fox","Cider",500,500,825),
("Old Mout","Cider",500,500,690),
("Budvar","Beer",330,330,495),
("Augustiner","Beer",500,500,750);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price)
VALUES ("Ketel One","Vodka",25,700,490),
("Botanist","Gin",25,700,490),
("Wolfstown","Gin",25,700,490),
("Cuckoo Sunshine","Gin",25,700,540),
("Lancaster Firecracker","Gin",25,700,540),
("Stormy Bay","Gin",25,700,540);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price)
VALUES ("Bushmills","Whiskey",25,700,460),
("Bulleit Bourbon","Bourbon",25,700,540),
("Buffalo Trace","Bourbon",25,700,490),
("Highland Park","Whiskey",25,700,540),
("Bruichladdich","Whiskey",25,700,650),
("Caol Ila","Whiskey",25,700,650);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price)
VALUES ("Havana Club","Rum",25,700,440),
("Kraken","Rum",25,700,490),
("Don Papa","Rum",25,700,540),
("Plantation Pineapple","Rum",25,700,540),
("Mount Gay","Whiskey",25,700,650);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price)
VALUES ("Disaronno","Liqueur",25,700,380),
("Cointeau","Liqueur",25,700,380),
("Metaxa","Brandy",25,700,460),
("Remy Martin VSOP","Brandy",25,700,650),
("Remy Martin 1738","Brandy",25,700,720);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price)
VALUES ("Pocas 10 Yr","Port",50,700,540),
("Colosia Gutierrez","Sherry",50,700,740);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Drink_Serving_Size,Bottle_Size,Drink_Price)
VALUES ("Karma Cola","Soft",250,250,320),
("Karma Cola SF","Soft",250,250,320),
("Lemony Lemonade","Soft",250,250,320),
("Big Tom","Soft",100,750,350),
("Sparkling Water","Soft",750,750,390),
("Orange Juice","Soft",200,1000,290),
("Apple Juice","Soft",200,1000,290),
("Grapefruit Juice","Soft",200,1000,290),
("Pineapple Juice","Soft",200,1000,290);


INSERT INTO Drink_List(Drink_Name,Drink_Type,Bottle_Size,Drink_Serving_Size,Drink_Price)
VALUES ("Campo Nuevo","White",1000,175,98765),
("Gruner Veltliner","White",1000,1000,2600),
("Fiano","White",1000,175,98765),
("Viognier","White",1000,1000,29000),
("Picpoul de Pinet","White",1000,1000,3100),
("Rioja Tempranillo","White",1000,1000,3200),
("Sauvignon Blanc Kuki","White",1000,175,98765),
("Riesling","White",1000,1000,3600),
("Albarino","White",1000,1000,3700),
("Giato Grillo","White",1000,1000,3900),
("Sancerre","White",1000,1000,3700);


INSERT INTO Drink_List(Drink_Name, Drink_Type, Bottle_Size, Drink_Serving_Size, Drink_Price)
VALUES 
('French Connection', 'A', 250, 250, 1000),
('Espresso Martini', 'A', 250, 250, 1000),
('Old Fashioned', 'A', 250, 250, 1000),
('Rhubarb Negroni', 'A', 250, 250, 1000),
('Hemingway Daiquiri', 'A', 250, 250, 1000),
('Bloody Mary', 'A', 250, 250, 900),
('Tea & G', 'A', 250, 250, 900),
('Aperol Spritz', 'A', 250, 250, 900),
('Elderflower Bellini', 'A', 250, 250, 900),
('Little Susie', 'A', 250, 250, 900),
('Mimosa', 'A', 250, 250, 850),
('Whiskey Before Breakfast', 'A', 250, 250, 800),
('Mauresque', 'A', 250, 250, 750),
('Apple N Eve', 'NA', 250, 250, 650),
('Mokito', 'NA', 250, 250, 700),
('Shirly Temple', 'NA', 250, 250, 750);



INSERT INTO Drink_List(Drink_Name,Drink_Type,Bottle_Size,Drink_Serving_Size,Drink_Price)
VALUES ("Prosecco Amori","Sparkling",1000,125,98765),
("Mas Comtal","Sparkling",1000,1000,4200),
("Champagne Moet","Sparkling",1000,1000,8500);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Bottle_Size,Drink_Serving_Size,Drink_Price)
VALUES ("Campo Nuevo Temp","Red",1000,175,98765),
("Primitivo","Red",1000,1000,2600),
("Malbec","Red",1000,175,98765),
("Coroa d'Ouro","Red",1000,1000,29000),
("Cotes du Rhone","Red",1000,175,98765),
("Rioja Crianza","Red",1000,1000,3300),
("Pinot Noir","Red",1000,1000,3400),
("Mas Comtal","Red",1000,1000,3500),
("Chateau de Campuget","Red",1000,1000,3600),
("Avondale","Red",1000,1000,3900),
("Chateu Corbin","Red",1000,1000,4500);

INSERT INTO Drink_List(Drink_Name,Drink_Type,Bottle_Size,Drink_Serving_Size,Drink_Price)
VALUES ("Mas Comtal Rosat","Rose",1000,175,98765),
("San Marzano","Rose",1000,1000,3500);


INSERT INTO Wine_Price (DrinkID,Wine_Price,Wine_Price_Type) 
VALUES (97,650,"Glass"),
(97,2400,"Bottle"),
(99,720,"Glass"),
(99,2800,"Bottle"),
(103,825,"Glass"),
(103,3400,"Bottle"),
(108,650,"Glass"),
(108,3100,"Bottle"),
(111,650,"Glass"),
(111,2400,"Bottle"),
(113,720,"Glass"),
(113,2800,"Bottle"),
(115,760,"Glass"),
(115,3200,"Bottle"),
(122,720,"Glass"),
(122,2800,"Bottle");

INSERT INTO Food_List(

INSERT INTO Drink_Stock (DrinkID,Drink_Count)
VALUES (54,24),
(56,24),
(57,24),
(58,24),
(59,24),
(60,24),
(61,24),
(62,14),
(63,14),
(64,14),
(65,14),
(66,14),
(67,24),
(68,24),
(69,2),
(70,2),
(71,2),
(72,2),
(73,2),
(74,2),
(75,2),
(76,2),
(77,2),
(78,2),
(79,2),
(80,2),
(81,2),
(82,2),
(83,2),
(84,2),
(85,2),
(86,2),
(87,2),
(88,24),
(89,24),
(90,24),
(91,4),
(92,6),
(93,6),
(94,6),
(95,6),
(96,6),
(97,6),
(98,6),
(99,6),
(100,6),
(101,6),
(102,6),
(103,6),
(104,6),
(105,6),
(106,6),
(107,6),
(108,6),
(109,6),
(110,6),
(111,6),
(112,6),
(113,6),
(114,6),
(115,6),
(116,6),
(117,6),
(118,6),
(119,6),
(120,6),
(121,6),
(122,6),
(123,6);

INSERT INTO Drink_Recipe (Drink_RecipeName,Drink_RecipeInstructions,Drink_RecipeGarnish,Drink_Recipe_Price)
Values ('French Connection','A','lemon',10000),
('Espresso Martini','A','espresso',10000),
('Old Fashioned','A','orange',10000),
('Rhubarb Negroni','A','rhubarb',10000),
('Hemingway Daiquiri','A','lime',10000),
('Bloody Mary','A','celery',9000),
('Tea & G','A','lemon',9000),
('Aperol Spritz','A','orange',9000),
('Elderflower Bellini','A','mint',9000),
('Little Susie','A','tonic',9000),
('Mimosa','A','orange',8500),
('Whiskey Before Breakfast','A','marmalade',8000),
('Mauresque','A','almond',7500),
('Apple N Eve','NA','lemon',6500),
('Mokito','NA','mint',7000),
('Shirly Temple','NA','lime',7500);

INSERT INTO Drink_Recipe_Link(Drink_RecipeID,DrinkID,Drink_Ingredient_Quantity)
VALUES(1,84,1),
(1,81,1),
(2,64,1),
(2,64,1),
(3,71,1),
(4,69,1),
(4,128,1),
(5,76,1),
(5,95,1),
(6,64,1),
(6,91,1),
(7,65,1),
(8,128,1),
(8,108,1),
(9,108,1),
(9,94,1),
(10,72,1),
(10,82,1),
(11,82,1),
(11,108,1),
(11,93,1),
(12,72,1),
(13,86,1),
(14,94,1),
(15,94,1),
(16,93,1);

INSERT INTO Food_List(Food_Name,Food_Expiratory,Food_Serving_Size,Food_Base_Size)
Values
('almond', 180, 1, 20),
('star anise', 365, 1, 15),
('apple', 30, 1, 5),
('mint', 7, 1, 10),
('orange', 30, 1, 5),
('bread', 5, 1, 10),
('salsa verde', 7, 1, 10),
('olives', 30, 1, 10),
('sundried tomatoes', 180, 1, 15),
('artichokes', 30, 1, 10),
('olives', 30, 1, 20),
('caperberries', 365, 1, 20),
('guindilla chillies', 30, 1, 15),
('hummus', 7, 1, 10),
('pink pickled onions', 30, 1, 20),
('sumac', 365, 1, 20),
('chilli', 30, 1, 15),
('sesame', 180, 1, 20),
('garlic oil', 30, 1, 10),
('flatbread', 7, 1, 10),
('bacon popcorn', 30, 1, 15),
('cockles and mussels', 30, 1, 15),
('king prawns', 3, 1, 10),
('garlic and thyme butter', 7, 1, 10),
('oysters', 3, 1, 1),
('mushroom terrine', 7, 1, 10),
('butterbean puree', 7, 1, 10),
('pickled walnut ketchup', 30, 1, 15),
('chicken wings', 2, 1, 10),
('house slaw', 3, 1, 10),
('blue cheese dip', 7, 1, 10),
('Duck eclair', 2, 1, 5),
('orange chutney', 30, 1, 20),
('hoi sin', 30, 1, 20),
('pistachio', 180, 1, 20),
('aubergine', 7, 1, 5),
('lentil moussaka', 7, 1, 10),
('baked cod', 2, 1, 10),
('cassoulet', 7, 1, 10),
('goats cheese', 7, 1, 10),
('tomatoes', 7, 1, 10),
('wild garlic', 7, 1, 10),
('balsamic', 365, 1, 20),
('charcuterie', 30, 1, 10),
('rocket', 5, 1, 10),
('horseradish dressing', 7, 1, 10),
('crab', 2, 1, 5),
('yuzu and saffron aioli', 7, 1, 10),
('king scallops', 2, 1, 5),
('pomegranate', 30, 1, 10),
('lemon', 30, 1, 10),
('chilli', 30, 1, 15),
('samphire', 7, 1, 10),
('fillet steak', 3, 1, 5),
('asparagus', 7, 1, 10),
('courgette', 7, 1, 10),
('butterbean puree', 7, 1, 10),
('smoked garlic and thyme butter', 7, 1, 10),
('chateaubriand', 3, 1, 5),
('crevettes', 2, 1, 10),
('scallops', 2, 1, 5),
('Marrot', 7, 1, 10),
('blood orange salad', 7, 1, 10),
('radicchio', 7, 1, 10),
('walnut vinaigrette', 30, 1, 15),
('french toast', 7, 1, 10),
('truffle honey', 180, 1, 20),
('fellstone cheese', 7, 1, 10),
('potatoes', 7, 1, 10),
('romesco sauce', 7, 1, 10);

INSERT INTO Food_Recipe(Food_RecipeName, Food_RecipeTTC, Food_RecipeType,Food_RecipePrice) VALUES
('Artisan bread', 1, 'Nibble', 250),
('Marinated olives', 1, 'Nibble', 600),
('Mixed antipasti', 1, 'Nibble', 600),
('Hummus', 2, 'Nibble', 750),
('Smoked bacon popcorn', 1, 'Nibble', 400),
('Cockles and mussels', 1, 'Nibble', 500),
('Whole king prawns', 2, 'Nibble', 950),
('Oysters', 2, 'Nibble', 400),
('Wild mushroom terrine', 5, 'Small Plate', 950),
('Habanero and lime chicken wings', 10, 'Small Plate', 1000),
('Duck eclair', 5, 'Small Plate', 1000),
('Aubergine and lentil moussaka', 10, 'Small Plate', 1300),
('Nduja baked cod', 10, 'Small Plate', 1600),
('Goats cheese', 5, 'Small Plate', 1100),
('Charcuterie', 5, 'Small Plate', 1000),
('Dressed crab', 5, 'Small Plate', 1600),
('Scallops', 10, 'Small Plate', 1600),
('Fillet steak', 10, 'Small Plate', 3000),
('Chateaubriand', 10, 'Small Plate', 4500),
('Carrot and blood orange salad', 5, 'Small Plate', 850),
('Wild garlic french toast', 5, 'Small Plate', 850),
('Garlic and herb potatoes', 5, 'Small Plate', 750);



INSERT INTO Food_Recipe_Link (FoodId, Food_RecipeID) VALUES
(6, 1), (7, 1),  --  Artisan bread
(8, 2),  -- Marinated olives
(9, 3), (10, 3), (8, 3), (12, 3), (13, 3),  -- Mixed antipasti
(14, 4), (16, 4), (17, 4), (19, 4), (20, 4),  -- Hummus
(21, 5),  -- Smoked bacon popcorn
(22, 6),  -- Pickled Morecambe Bay cockles and mussels
(23, 7), (24, 7),   -- Whole king prawns
(25, 8),  --  Oysters
(26,9),(27,9),(28,9), --mush errine
(29, 10), (30, 10), (31, 10),   -- chicken wings
(32, 11), (33, 11), (34, 11), (35, 11),  -- Duck eclair
(36, 12), (37, 12), -- moussaka
(38, 13), (39, 13),   -- Nduja baked cod
(40, 14), (41, 14), (42, 14), (43, 14),  -- Elrick goats cheese
(44, 15), (45, 15), (46, 15),  -- Charcuterie
(47, 16), (48, 16),   -- crab
(49, 17), (50, 17), (51, 17), (17, 17),  -- scallops
(54, 18), (55, 18), (27, 18), (24, 18),  -- Fillet steak
(59, 19),(24,19),(60,19),  -- Chateaubriand
(63, 20),(64,20),(65,20),  -- carrot and orange salad
(66, 21), (67, 21), (68, 21),  -- french toast
(69, 22),(70,22);  -- potatoes







-- Wild Mushroom Terrine
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(9, 98, 103, 100, 117, 108, 132, 137, 84, 143);

-- Habanero and Lime Chicken Wings
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(10, 103, 108, 104, 100, 109, 117, 133, 134, 144);

-- Duck Eclair
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(11, 117, 107, 98, 115, 97, 131, 132, 140, 142);

-- Aubergine and Lentil Moussaka
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(12, 115, 113, 120, 119, 97, 112, 134, 92, 143);

-- Nduja Baked Cod
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(13, 103, 105, 99, 101, 108, 132, 133, 138, 144);

-- Goats Cheese
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(14, 107, 100, 101, 99, 98, 137, 136, 139, 143);

-- Charcuterie
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(15, 116, 120, 113, 119, 97, 131, 132, 140, 142);

-- Dressed Crab
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(16, 105, 103, 101, 104, 108, 137, 133, 138, 144);

-- Scallops
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(17, 107, 103, 104, 105, 108, 137, 133, 138, 143);

-- Fillet Steak
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(18, 113, 115, 121, 119, 97, 131, 132, 140, 142);

-- Chateaubriand
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(19, 121, 113, 119, 115, 116, 131, 132, 140, 142);

-- Carrot and Blood Orange Salad
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(20, 103, 98, 101, 99, 108, 137, 136, 139, 143);

-- Wild Garlic French Toast
INSERT INTO Drink_Reccomend (Food_RecipeID, DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID)
VALUES 
(21, 107, 100, 98, 99, 108, 137, 139, 133, 143);


INSERT INTO Recipe_Recipe_Link (Food_RecipeID, Pair1ID, Pair2ID, Pair3ID, Pair4ID, Pair5ID, Pair6ID)
VALUES
(9, 12, 14, 20, 21, 2, 4),  -- Wild Mushroom Terrine
(10, 13, 17, 18, 15, 6, 7),  -- Habanero and Lime Chicken Wings
(11, 15, 18, 17, 13, 5, 1),  -- Duck Eclair
(12, 9, 14, 20, 21, 2, 4),   -- Aubergine and Lentil Moussaka
(13, 18, 11, 17, 15, 7, 6),  -- Nduja Baked Cod
(14, 9, 12, 20, 21, 2, 4),   -- Elrick Goat's Cheese
(15, 11, 18, 17, 13, 5, 1),  -- Charcuterie
(16, 17, 18, 13, 15, 7, 6),  -- Dressed Cumbrian Shore Crab
(17, 13, 18, 11, 15, 7, 6),  -- Pan-Seared King Scallops
(18, 17, 13, 11, 15, 7, 6),  -- Fillet Steak
(19, 17, 13, 11, 15, 7, 6),  -- Chateaubriand
(20, 9, 14, 12, 21, 2, 4),   -- Maple Roasted Carrot and Blood Orange Salad
(21, 9, 14, 12, 20, 2, 4);   -- Wild Garlic French Toast




UPDATE Drink_List
SET Probability = CASE
    WHEN Drink_Name = 'Helles' THEN 0.0250
    WHEN Drink_Name = 'Chaff' THEN 0.0210
    WHEN Drink_Name = 'Easy Sunshine' THEN 0.0230
    WHEN Drink_Name = 'Budvar' THEN 0.0190
    WHEN Drink_Name = 'Augustiner' THEN 0.0230
    WHEN Drink_Name = 'Ketel One' THEN 0.0000
    WHEN Drink_Name = 'Botanist' THEN 0.0040
    WHEN Drink_Name = 'Wolfstown' THEN 0.0030
    WHEN Drink_Name = 'Cuckoo Sunshine' THEN 0.0040
    WHEN Drink_Name = 'Lancaster Firecracker' THEN 0.0050
    WHEN Drink_Name = 'Stormy Bay' THEN 0.0070
    WHEN Drink_Name = 'Bushmills' THEN 0.0070
    WHEN Drink_Name = 'Bulleit Bourbon' THEN 0.0050
    WHEN Drink_Name = 'Buffalo Trace' THEN 0.0020
    WHEN Drink_Name = 'Highland Park' THEN 0.0010
    WHEN Drink_Name = 'Caol Ila' THEN 0.0020
    WHEN Drink_Name = 'Havana Club' THEN 0.0110
    WHEN Drink_Name = 'Kraken' THEN 0.0060
    WHEN Drink_Name = 'Don Papa' THEN 0.0010
    WHEN Drink_Name = 'Plantation Pineapple' THEN 0.0070
    WHEN Drink_Name = 'Disaronno' THEN 0.0450
    WHEN Drink_Name = 'Cointeau' THEN 0.0120
    WHEN Drink_Name = 'Metaxa' THEN 0.0010
    WHEN Drink_Name = 'Remy Martin VSOP' THEN 0.0130
    WHEN Drink_Name = 'Pocas 10 Yr' THEN 0.0010
    WHEN Drink_Name = 'Colosia Gutierrez' THEN 0.0000
    WHEN Drink_Name = 'Karma Cola' THEN 0.0430
    WHEN Drink_Name = 'Karma Cola SF' THEN 0.0060
    WHEN Drink_Name = 'Lemony Lemonade' THEN 0.0340
    WHEN Drink_Name = 'Big Tom' THEN 0.0080
    WHEN Drink_Name = 'Sparkling Water' THEN 0.0350
    WHEN Drink_Name = 'Orange Juice' THEN 0.0450
    WHEN Drink_Name = 'Apple Juice' THEN 0.0340
    WHEN Drink_Name = 'Grapefruit Juice' THEN 0.0100
    WHEN Drink_Name = 'Pineapple Juice' THEN 0.0090
    WHEN Drink_Name = 'Campo Nuevo' THEN 0.0650
    WHEN Drink_Name = 'Gruner Veltliner' THEN 0.0020
    WHEN Drink_Name = 'Fiano' THEN 0.0100
    WHEN Drink_Name = 'Viognier' THEN 0.0020
    WHEN Drink_Name = 'Picpoul de Pinet' THEN 0.0160
    WHEN Drink_Name = 'Rioja Tempranillo' THEN 0.0100
    WHEN Drink_Name = 'Sauvignon Blanc Kuki' THEN 0.0450
    WHEN Drink_Name = 'Riesling' THEN 0.0060
    WHEN Drink_Name = 'Albarino' THEN 0.0030
    WHEN Drink_Name = 'Giato Grillo' THEN 0.0030
    WHEN Drink_Name = 'Sancerre' THEN 0.0060
    WHEN Drink_Name = 'Prosecco Amori' THEN 0.0350
    WHEN Drink_Name = 'Mas Comtal' THEN 0.0080
    WHEN Drink_Name = 'Champagne Moet' THEN 0.0020
    WHEN Drink_Name = 'Campo Nuevo Temp' THEN 0.0290
    WHEN Drink_Name = 'Primitivo' THEN 0.0060
    WHEN Drink_Name = 'Malbec' THEN 0.0340
    WHEN Drink_Name = 'Cotes du Rhone' THEN 0.0240
    WHEN Drink_Name = 'Rioja Crianza' THEN 0.0050
    WHEN Drink_Name = 'Pinot Noir' THEN 0.0040
    WHEN Drink_Name = 'Chateau de Campuget' THEN 0.0030
    WHEN Drink_Name = 'Avondale' THEN 0.0020
    WHEN Drink_Name = 'Chateau Corbin' THEN 0.0010
    WHEN Drink_Name = 'Mas Comtal Rosat' THEN 0.0240
    WHEN Drink_Name = 'San Marzano' THEN 0.0040
    WHEN Drink_Name = 'Aperol' THEN 0.0000
    WHEN Drink_Name = 'French Connection' THEN 0.0000
    WHEN Drink_Name = 'Espresso Martini' THEN 0.0670
    WHEN Drink_Name = 'Old Fashioned' THEN 0.0640
    WHEN Drink_Name = 'Rhubarb Negroni' THEN 0.0430
    WHEN Drink_Name = 'Hemingway Daiquiri' THEN 0.0150
    WHEN Drink_Name = 'Bloody Mary' THEN 0.0340
    WHEN Drink_Name = 'Tea & G' THEN 0.0120
    WHEN Drink_Name = 'Aperol Spritz' THEN 0.0630
    WHEN Drink_Name = 'Elderflower Bellini' THEN 0.0560
    WHEN Drink_Name = 'Little Susie' THEN 0.0230
    WHEN Drink_Name = 'Mimosa' THEN 0.0570
    WHEN Drink_Name = 'Whiskey Before Breakfast' THEN 0.0120
    WHEN Drink_Name = 'Mauresque' THEN 0.0150
    WHEN Drink_Name = 'Apple N Eve' THEN 0.0340
    WHEN Drink_Name = 'Mokito' THEN 0.0240
    WHEN Drink_Name = 'Shirly Temple' THEN 0.0230
    ELSE NULL
END;




--Checking Availability
SELECT t.TableID, t.TableNumber, t.Capacity
FROM Tables t
LEFT JOIN TableAvailability ta ON t.TableID = ta.TableID
WHERE ta.Date = '2024-07-15'
AND ta.TimeSlot = '18:00-20:00'
AND ta.IsAvailable = TRUE;

--Creating a Booking

INSERT INTO Customers (Surname) VALUES ('Smith');
INSERT INTO Bookings (CustomerID, TableID, BookingDateTime, Duration, Status)
VALUES (LAST_INSERT_ID(), 1, '2024-07-15 18:00:00', 2, 'Confirmed');

--Updating Availability

UPDATE TableAvailability
SET IsAvailable = FALSE
WHERE TableID = 1
AND Date = '2024-07-15'
AND TimeSlot = '18:00-20:00';

INSERT INTO Tables (TableNumber, Capacity) VALUES
(1, 4),
(2, 4),
(3, 4),
(4, 4),
(5, 6),
(6, 6),
(7, 4),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 5);




INSERT INTO Food_Stock (FoodId, Food_Count, Food_Expiratory_Date)
VALUES
-- Almond (180 days expiration)
(1, CEIL((180/7 * 1000 * 0.229) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 180 DAY)),
-- Star anise (365 days expiration)
(2, CEIL((365/7 * 1000 * 0.166) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 365 DAY)),
-- Apple (30 days expiration)
(3, CEIL((30/7 * 1000 * 0.070) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Mint (7 days expiration)
(4, CEIL((7/7 * 1000 * 0.094) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Orange (30 days expiration)
(5, CEIL((30/7 * 1000 * 0.094) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Bread (5 days expiration)
(6, CEIL((5/7 * 1000 * 0.229) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY)),
-- Salsa verde (7 days expiration)
(7, CEIL((7/7 * 1000 * 0.229) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Olives (30 days expiration)
(8, CEIL((30/7 * 1000 * 0.166) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Sundried tomatoes (180 days expiration)
(9, CEIL((180/7 * 1000 * 0.070) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 180 DAY)),
-- Artichokes (30 days expiration)
(10, CEIL((30/7 * 1000 * 0.070) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Caperberries (365 days expiration)
(12, CEIL((365/7 * 1000 * 0.070) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 365 DAY)),
-- Guindilla chillies (30 days expiration)
(13, CEIL((30/7 * 1000 * 0.070) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Hummus (7 days expiration)
(14, CEIL((7/7 * 1000 * 0.094) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Pink pickled onions (30 days expiration)
(15, CEIL((30/7 * 1000 * 0.048) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Sumac (365 days expiration)
(16, CEIL((365/7 * 1000 * 0.058) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 365 DAY)),
-- Chilli (30 days expiration)
(17, CEIL((30/7 * 1000 * 0.050) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Sesame (180 days expiration)
(18, CEIL((180/7 * 1000 * 0.169) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 180 DAY)),
-- Garlic oil (30 days expiration)
(19, CEIL((30/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Flatbread (7 days expiration)
(20, CEIL((7/7 * 1000 * 0.117) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Bacon popcorn (30 days expiration)
(21, CEIL((30/7 * 1000 * 0.125) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Cockles and mussels (30 days expiration)
(22, CEIL((30/7 * 1000 * 0.165) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- King prawns (3 days expiration)
(23, CEIL((3/7 * 1000 * 0.165) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)),
-- Garlic and thyme butter (7 days expiration)
(24, CEIL((7/7 * 1000 * 0.155) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Oysters (3 days expiration)
(25, CEIL((3/7 * 1000 * 0.105) / 1) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)),
-- Mushroom terrine (7 days expiration)
(26, CEIL((7/7 * 1000 * 0.145) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Butterbean puree (7 days expiration)
(27, CEIL((7/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Pickled walnut ketchup (30 days expiration)
(28, CEIL((30/7 * 1000 * 0.115) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Chicken wings (2 days expiration)
(29, CEIL((2/7 * 1000 * 0.075) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY)),
-- House slaw (3 days expiration)
(30, CEIL((3/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)),
-- Blue cheese dip (7 days expiration)
(31, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Duck eclair (2 days expiration)
(32, CEIL((2/7 * 1000 * 0.110) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY)),
-- Orange chutney (30 days expiration)
(33, CEIL((30/7 * 1000 * 0.194) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Hoi sin (30 days expiration)
(34, CEIL((30/7 * 1000 * 0.070) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Pistachio (180 days expiration)
(35, CEIL((180/7 * 1000 * 0.090) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 180 DAY)),
-- Aubergine (7 days expiration)
(36, CEIL((7/7 * 1000 * 0.105) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Lentil moussaka (7 days expiration)
(37, CEIL((7/7 * 1000 * 0.095) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Baked cod (2 days expiration)
(38, CEIL((2/7 * 1000 * 0.125) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY)),
-- Cassoulet (7 days expiration)
(39, CEIL((7/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Goats cheese (7 days expiration)
(40, CEIL((7/7 * 1000 * 0.075) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Tomatoes (7 days expiration)
(41, CEIL((7/7 * 1000 * 0.065) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Wild garlic (7 days expiration)
(42, CEIL((7/7 * 1000 * 0.075) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Balsamic (365 days expiration)
(43, CEIL((365/7 * 1000 * 0.090) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 365 DAY)),
-- Charcuterie (30 days expiration)
(44, CEIL((30/7 * 1000 * 0.155) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Rocket (5 days expiration)
(45, CEIL((5/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY)),
-- Horseradish dressing (7 days expiration)
(46, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Crab (2 days expiration)
(47, CEIL((2/7 * 1000 * 0.115) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY)),
-- Yuzu and saffron aioli (7 days expiration)
(48, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- King scallops (2 days expiration)
(49, CEIL((2/7 * 1000 * 0.110) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY)),
-- Pomegranate (30 days expiration)
(50, CEIL((30/7 * 1000 * 0.070) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Lemon (30 days expiration)
(51, CEIL((30/7 * 1000 * 0.070) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- Samphire (7 days expiration)
(53, CEIL((7/7 * 1000 * 0.070) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Fillet steak (3 days expiration)
(54, CEIL((3/7 * 1000 * 0.075) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)),
-- Asparagus (7 days expiration)
(55, CEIL((7/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Courgette (7 days expiration)
(56, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Chateaubriand (3 days expiration)
(59, CEIL((3/7 * 1000 * 0.038) / 5) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)),
-- Crevettes (2 days expiration)
(60, CEIL((2/7 * 1000 * 0.194) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY)),
-- Blood orange salad (7 days expiration)
(63, CEIL((7/7 * 1000 * 0.115) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Radicchio (7 days expiration)
(64, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Walnut vinaigrette (30 days expiration)
(65, CEIL((30/7 * 1000 * 0.110) / 15) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)),
-- French toast (7 days expiration)
(66, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Truffle honey (180 days expiration)
(67, CEIL((180/7 * 1000 * 0.110) / 20) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 180 DAY)),
-- Fellstone cheese (7 days expiration)
(68, CEIL((7/7 * 1000 * 0.110) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Potatoes (7 days expiration)
(69, CEIL((7/7 * 1000 * 0.194) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)),
-- Romesco sauce (7 days expiration)
(70, CEIL((7/7 * 1000 * 0.194) / 10) + 1, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY));




SELECT 
    fr.Food_RecipeID, 
    fr.Food_RecipeName, 
    frl.FoodID, 
    fl.Food_Name, 
    fl.Food_Base_Size, 
    fs.Food_Count, 
    fs.Food_Expiratory_Date,
    DATEDIFF(fs.Food_Expiratory_Date, CURDATE()) AS Days_Until_Expiration
FROM 
    Food_Recipe fr
JOIN 
    Food_Recipe_Link frl ON fr.Food_RecipeID = frl.Food_RecipeID
JOIN 
    Food_List fl ON frl.FoodID = fl.FoodId
JOIN 
    Food_Stock fs ON fl.FoodId = fs.FoodId;

    query = """

    """

SELECT dl.DrinkID, ds.Drink_Count, dl.Bottle_Size, dl.Drink_Serving_Size 
FROM Drink_Recipe_Link drl 
JOIN Drink_List dl ON drl.DrinkID = dl.DrinkID 
JOIN Drink_Stock ds ON dl.DrinkID = ds.DrinkID 
WHERE drl.Drink_RecipeID = %s


SELECT m.Title, m.Body, m.CreatedAt, mgr.ManagerName
FROM Messages m
JOIN Managers mgr ON m.ManagerID = mgr.ManagerID
ORDER BY m.CreatedAt DESC

SELECT Customers.Surname
FROM Bookings
JOIN Customers ON Bookings.CustomerID = Customers.CustomerID
WHERE Bookings.TableID = ID




SELECT o.OrderID, o.BookingID, o.OrderDateTime, t.TableNumber
        FROM Orders o
        JOIN Bookings b ON o.BookingID = b.BookingID
        JOIN Tables t ON b.TableID = t.TableID
        WHERE DATE(o.OrderDateTime) = CURDATE()


SELECT c.Surname, b.BookingDateTime, b.Duration
            FROM Bookings b
            JOIN Customers c ON b.CustomerID = c.CustomerID
            WHERE b.TableID = (SELECT TableID FROM Bookings WHERE BookingID = %s)
            AND b.BookingDateTime <= %s
            AND DATE_ADD(b.BookingDateTime, INTERVAL b.Duration HOUR) > %s

        SELECT f.Food_RecipeName, d.Drink_Name
        FROM OrderItems oi
        LEFT JOIN Food_Recipe f ON oi.Food_RecipeID = f.Food_RecipeID
        LEFT JOIN Drink_List d ON oi.DrinkID = d.DrinkID
        WHERE oi.OrderID = %s