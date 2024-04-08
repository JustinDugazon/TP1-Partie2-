-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:                        Votre DA: 
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL;
DESC OUTILS_USAGER;
DESC OUTILS_EMPRUNT;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT PRENOM || ' ' || NOM_FAMILLE
FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT VILLE
FROM OUTILS_USAGER
ORDER BY VILLE;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT *
FROM OUTILS_OUTIL
ORDER BY NOM, CODE_OUTIL;
-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT NUM_EMPRUNT
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT NUM_EMPRUNT
FROM OUTILS_EMPRUNT
WHERE DATE_EMPRUNT < DATE '2014-01-01';
-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE UPPER(CARACTERISTIQUES) LIKE 'J%'
-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE FABRICANT = 'Stanley';
-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT NOM, FABRICANT
FROM OUTILS_OUTIL
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3

SELECT CODE_OUTIL, NOM
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES NOT LIKE '%20 volt%';

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*)
FROM OUTILS_OUTIL
WHERE FABRICANT != 'Makita';
-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS NOM_COMPLET, NUM_EMPRUNT, DATE_RETOUR - DATE_EMPRUNT AS DUREE_EMPRUNT, PRIX
FROM OUTILS_EMPRUNT
JOIN OUTILS_USAGER ON OUTILS_EMPRUNT.NUM_USAGE = OUTILS_USAGER.NUM_USAGER
JOIN OUTILS_OUTIL ON OUTILS_EMPRUNT.CODE_OUTIL = OUTILS_OUTIL.CODE_OUTIL
WHERE VILLE IN ('Vancouver', 'Regina');

-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT OUTILS_OUTIL.NOM, OUTILS_OUTIL.CODE_OUTIL
FROM OUTILS_EMPRUNT
JOIN OUTILS.OUTIL ON  OUTILS_EMPRUNT.CODE_OUTIL = OUTILS_OUTIL.CODE_OUTIL
WHERE DATE_RETOUR IS NULL;
-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT NOM_FAMILLE, COURRIEL
FROM OUTILS_USAGER
WHERE NUM_USAGER NOT IN (SELECT DISTINCT NUM_USAGER FROM OUTILS_EMPRUNT);
-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT OUTILS_OUTIL.CODE_OUTIL, OUTILS_OUTIL.PRIX
FROM OUTILS_OUTIL
LEFT JOIN OUTILS_EMPRUNT ON OUTILS_OUTIL.CODE_OUTIL = OUTILS_EMPRUNT.CODE_OUTIL
WHERE OUTILS_EMPRUNT.CODE_OUTIL IS NULL;
-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT NOM, COALESCE(PRIX, AVG_PRIX) AS PRIX
FROM OUTILS_OUTIL
CROSS JOIN (SELECT AVG(PRIX) AS AVG_PRIX FROM OUTILS_OUTIL) AVG_PRICE
WHERE FABRICANT = 'Makita' AND (PRIX > AVG_PRIX OR PRIX IS NULL);
-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT U.PRENOM, U.NOM_FAMILLE, U.ADRESSE, O.NOM, O.CODE_OUTIL
FROM OUTILS_USAGER U
JOIN OUTILS_EMPRUNT E ON U.NUM_USAGER = E.NUM_USAGER
JOIN OUTILS_OUTIL O ON E.CODE_OUTIL = O.CODE_OUTIL
WHERE E.DATE_EMPRUNT > DATE '2014-01-01'
ORDER BY U.NOM_FAMILLE
-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT O.NOM, O.PRIX
FROM OUTILS_OUTIL O 
JOIN OUTILS_EMPRUNT E ON O.CODE_OUTIL = E.CODE_OUTIL
GROUP BY O.NOM, O.PRIX
HAVING COUNT(E.CODE_OUTIL) > 1;
-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT U.NOM_FAMILLE, U.ADRESSE, U.VILLE
FROM OUTILS_USAGER U
JOIN OUTILS_EMPRUNT E ON U.NUM_USAGER = E.NUM_USAGER;
--  IN
SELECT NOM_FAMILLE, ADRESSE, VILLE
FROM OUTILS_USAGER
WHERE NUM_USAGER IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);
--  EXISTS
SELECT NOM_FAMILLE, ADRESSE, VILLE
FROM OUTILS_USAGER U
WHERE EXISTS (SELECT 1 FROM OUTILS_EMPRUNT E WHERE E.NUM_USAGER = U.NUM_USAGER);
-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT FABRICANT, AVG(PRIX) AS MOYENNE_PRIX
FROM OUTILS_OUTIL
GROUP BY FABRICANT;
-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT VILLE, SUM(O.PRIX) AS SOMME_PRIX
FROM OUTILS_EMPRUNT E
JOIN OUTILS_USAGER U ON E.NUM_USAGER = U.NUM_USAGER
JOIN OUTILS_OUTIL O ON E.CODE_OUTIL = O.CODE_OUTIL
GROUP BY VILLE
ORDER BY SOMME_PRIX DESC;
-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('NE001', 'Nouvel Outil', 'Nouveau Fabricant', 'Caractéristiques du nouvel outil', 2024, 100);
-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('NE002', 'Autre Outil', 2023);
-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE CODE_OUTIL IN ('NE001', 'NE002');
-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);
