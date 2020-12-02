doubleMe x = x + x
doubleUs x y = doubleMe x + doubleMe y
doubleSmallNumber x = if x > 100 
                      then x 
                      else x*2
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1

-- Haskell komentari se pisu sa dve crtice
-- Haskell nema promenljive, ali sa naredbom let mozemo definisati unutar ghci-a funkciju koja izgleda kao promenljiva 
-- tj prima povratnu vrednost nekog izraza koji moze vracati sam sebe. Koliko vidim, ghci prima takve izraze i bez let
-- ali dobro ga je koristiti za svaki slucaj. U skriptama ne mora posto je sam izraz dovoljan. npr a = 1.

-- if statement mora imati else u haskelu posto je u pitanju izraz koji mora imati povratnu vrednost
-- haskel slabo tolerise tab, zato ga treba izbegavati. Gore navedena funkcija sa if koristi samo space a ne tab!!!
-- karakter ' nema nikakvo posebno znacenje za kompajler pa se slobodno moze koristiti u imenovanju
-- karakter ' se cesto koristi da programerima indikuje da je neka funkcija striktna u evaluaciji
-- IMENA FUNKCIJA NE MOGU POCINJATI VELIKIM SLOVOM!!!

conanO'Brien = "It's a-me, Conan O'Brien!"

-- operator : se koristi da doda stvari na pocetak neke liste
-- npr 5:[1,2,3,4,5] ili 'A':" SMALL CAT". Haskell string " SMALL CAT" interno razvija u listu [' ','S','M','A','L','L',' ','C','A','T']
-- tako da je 'A':" SMALL CAT" isto sto i 'A':[' ','S','M','A','L','L',' ','C','A','T']
-- listi po vremenu pristupa funcionise slicno imperativnim jezicima.

-- zadavanje liste [1,2,3] je isto sto i 1:2:3:[] gde je [] prazna lista
-- liste mogu sadrzati liste u sebi tipa [[1,2,3]] ili [[1,2],[3,4],[5,6]]
-- vadjenje iz liste po indeksu radi operator !! . Indeksi pocinju od 0
-- "Steve Buscemi" !! 6 vraca 'B'
-- liste i liste unutar listi moraju imati usaglasene tipove svojih clanova

-- neki od operatora listi:
-- 1. komparativni >,<,<=,>= uporede elemente istih indeksa sa prioritetom od pocetka ka kraju
-- 2. dodavanje elemenata sa ++ na kraj ili na pocetak liste, i sa : na pocetak.
-- 3. vracanje delova liste: head(prvi element), tail(svi sem prvog), last(zadnji), init{svi sem zadnjeg)
-- NAPOMENA: Mora jako da se vodi racuna o tome da se ovi operatori ne primene na praznu listu!!!
-- 4. length [...] - vraca duzinu liste. null - vraca da li je lista prazna(true,false)
-- 5. reverse [..]- ispisuje listu unazad. take n [...]- uzima prvih n elemenata
-- 6. drop n [..] - uzima listu bez prvih n elemenata. minimum [...], maximum [...]
-- 7. sum [...] - vraca sumu liste. product [...] - vraca proizvod
-- 8. x `elem` [...] ili elem x [...] proverava da li je element u listi
-- NAPOMENA: za funkcije sa dva argumenta, funkcija se moze pozvati sa x `function` y !!! 
-- 9. Funkcije koje kreiraju beskonacne liste: cycle [..] - ponavlja zadatu listu u beskonacnost. 
-- 10. repeat x - pravi listu sa beskonacno ponavljanja x(haskell je lazy evaluator, ne pravi stvarno ali ima u vidu obrazac)
-- 11. replicate n x - pravi listu sa n ponavljanja x.

-- Liste se mogu praviti zadavanjem matematicke forme slicno S={2*x | x e N, x<=10}.
-- primer ovoga u haskelu je [x*2 | x <- [1..10]]
-- u navedenom primeru nema navedenog uslova koji se primenjuje na skupu brojeva!
-- Generalna struktura ovog izraza je dakle sledeca [funkcija | skup elemenata, uslov]
-- npr [x*2 | x <- [1..10]. x*2 >= 12] ili [x | x <- [50..100], x `mod` 7 == 3]

boomBang xs = [ if x < 10 then "Boom" else "Bang" | x <- xs, odd x ]

-- ovde je primera radi umesto funkcije dosao if izraz, ali s obzirom da if takodje uvek vraca vrednost kao f-ja, to je ok.
-- Bitna stvar. na ovaj nacin se moze definisati vise skupova za vise "promenljivih", a takodje se na kraju moze definisati vise uslova odvojenih zarezom
-- ali se mogu i objedinjavati logickim operatorima && i ||.
-- npr  [x | x <- [10..20],  x /= 15, x /= 17] ili [x | x <- [10..20],  x /= 15 && x /= 17] rade isto
-- primer za vise "promenljivih" tj vise argumenata unutar funkcije (posto to ipak nisu promenljive jbg)

putaPuta xs ys = [ x*y | x <- xs, y <- ys ]

-- ovde su xs i ys liste argumenata iz kojih se uzimaju argumenti pojedinacni za * funkciju
-- i prave se sve kombinacije njihove tako da je ovo svojevrsna dvostruka FOR petlja!!!
-- Bitno je da se telo funkcije stavi pre pipe simbola |, i radice kao sto bi for petlja radila!!
-- naravno, moguce je na kraju postavljati uslove za x i y, npr x*y>20.s

--primer alternativne length funkcije

length' xs = sum [ 1 | _ <- xs ]

--  donja crtica _ ovde znaci da je nebitno koji je element xs tako da se nece upisivati nigde, tj odsustvo izraza. to je napomena kompajleru jelte.

removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]

--primer dvostrukog ugnjezdenja list comprehensiona: [ [ x | x <- xs, even x ] | xs <- xxs] - ovo uklanja sve neparne brojeve iz liste koja sadrzi liste brojeva

-- Haskell na svojevrsan nacin implementira mape. Ovde se zovu tupl-ovi, i lice na liste koje u sebi sadrze skupove vrednosti koje ne moraju biti istog tipa!!!
-- doduse unutar jednog skupa moraju biti tipovi koji su isti kao i u svim ostalim parovima unutar jedne takve strukture!!
-- tuplovi se stavljaju u obicne zagrade ()
-- Primer strukture koja sadrzi tuplove je npr [("Christopher", "Walken", 75), ("Sean", "Connery", 90)] - kao sto se vidi tipovi tripleta su usaglaseni medjusobno unutar []

-- funkcije koje rade sa tuplovima su npr fsd - vraca prvi element, i snd - vraca drugi element para

-- zip xs ys je funkcija koja pravi tuplove od parova iz dve liste. rezultat je duzine krace od dve liste.
-- sledeci deo je mala skripta za izracunavanje pravouglog trougla obima 24 sa celobrojnim stranicama manje jednakim deset

triangle = [ (a,b,c) | a <- [1..10], b <- [1..a], c <- [1..b], (a + b > c) && (a + c > b) && (b + c > a) ]
rightTriangle = [ (a,b,c) |  a <- [1..10], b <- [1..a], c <- [1..b], a*a == b*b + c*c ]
perimeter24 = [ (a,b,c) | a <- [1..10], b <- [1..a], c <- [1..b], a + b + c == 24 && a*a == b*b + c*c ]







