data evq.EVQ_ZOUAGHI_AITCHARKI_VOEDZO; set  evq.evq_psm14_1860; 
run;

data evq; set evq.EVQ_ZOUAGHI_AITCHARKI_VOEDZO;
keep P14C01 AGE14 SEX14 REGION14 H14H14 H14H29 H14H27 P14A01 P14A04 P14C12 P14C15 I14PTOTN EDYEAR14 WSTAT14 CSPMAJ14;
run;

/* Création de format */
proc format library = work.formats;
value sante
-8 = '-8 : autre erreur'
-7 = '-7 : erreur de filtre'
-3 = '-3 : inapplicable'
-2 = '-2 : pas de réponse'
-1 = '-1 : ne sait pas'
1 = '1 : Très bien'
2 = '2 : Bien'
3 = '3 : Moyen'
4 = '4 : Mal'
5 = '5 : Très mal';

value region
-8 = '-8 : autre erreur'
-7 = '-7 : erreur de filtre'
-3 = '-3 : inapplicable'
-2 = '-2 : pas de réponse'
-1 = '-1 : ne sait pas'
1 = '1 : Région lémanique (VD, VS, GE)'
2 = '2 : Espace Mittelland (BE, FR, SO, NE, JU)'
3 = '3 : Suisse du Nord-Ouest (BS, BL, AG)'
4 = '4 : Zurich'
5 = '5 : Suisse orientale (GL, SH, AR, AI, SG, GR, TG)'
6 = '6 : Suisse centrale (LU, UR, SZ, OW, NW, ZG)'
7 = '7 : Tessin';

value sexe
1 = 'Homme'
2 = 'Femme';

value logement
-8 = '-8 : autre erreur'
-7 = '-7 : erreur de filtre'
-3 = '-3 : inapplicable'
-2 = '-2 : pas de réponse'
-1 = '-1 : ne sait pas'
1 = '1 : En mauvais état'
2 = '2 : En bon état mais pas rénové récemment'
3 = '3 : Neuf ou fraîchement rénové'
0 = '0 : Autres';

value pollution
-8 = '-8 : autre erreur'
-7 = '-7 :erreur de filtre'
-3 = '-3 : inapplicable'
-2 = '-2 : pas de réponse'
-1 = '-1 : ne sait pas'
0 = '0 : Autres'
1 = '1 : Oui'
2 = '2 : Non';

value P14C12_fmt 
1 = "Oui"
2 = "Non"
-3 = "Inapplicable"
-2 = "Pas de réponse"
-1 = "Ne sait pas";

value P14A01_fmt
1 = "Oui"
2 = "Non"
-3 = "Inapplicable"
-2 = "Pas de réponse"
-1 = "Ne sait pas";

value P14A04_fmt
-8 = "Autre erreur"
-7 = "Erreur de filtre"
-3 = "Inapplicable"
-2 = "Pas de réponse"
-1 = "Ne sait pas"
0 = "0 Jour"
1 = "1 Jour"
2 = "2 Jours"
3 = "3 Jours"
4 = "4 Jours"
5 = "5 Jours"
6 = "6 Jours"
7 = "7 Jours";

value P14C15_fmt
0 - 20 = "Entre 0 et 20 visites"
20 - 30 = "Entre 20 et 30 visites"
30 - high = "Plus de visites";
        
value IncomeClassF
-8 = "Données manquantes"
-7 = "Refus de répondre"
-3 = "Inapplicable"
0-39999 = "Revenus bas"
40000-79999 = "Revenus moyens"
80000-149999 = "Revenus élevés"
150000-high = "Revenus très élevés";

value $EducationGroupF
Non classé" = "Non classé"
"Bas" = "Bas"
"Moyen" = "Moyen"
"Élevé" = "Élevé"
"Très élevé" = "Très élevé"
"Non renseigné"" = "Non renseigné";

value WSTAT14F
1 = "Actifs occupés"
2 = "Chômeurs"
3 = "Non actifs"
-3 = "Inapplicable"
-1,-2 = "Non renseigné"
-8,-7 = "Erreur"
other = "Valeur non classée";  

value CSPMAJ14F
-3= "Inaplicable"
1 = "dirigeants"
2 = "professions libérales"
3 = "autres indépendants"
4 = "prof. intellectuelles et d'encadrement"
5 = "ntermédiaires"
6 = "Employés qualifiés"
7= "ouvriers qualifiés"
8="travailleurs non qualifiés";
run;


/* Detection des valeurs manquantes */
proc means data = evq1 n nmiss; 
run;

/* modalites atypiques concernant la variable dependante*/
/* Variable dependante : P14C01 */
proc freq data = evq1;
table P14C01;
run;
/*
proc sql;
select * from evq
where P14C01 = -3;
quit;
run;
+/
data filtre; set evq1;
if P14C01 in (-1, -2, -3) then delete; /* les modalites -3, -2 et -1 ont ete supprime pour eviter de fausser notre modelisation*/
run;

/* modalites atypiques concernant nos variables explicatives*/
/* Ces modalites ont ete regroupes dans une modalite nommee autres codee 0 afin d'eviter d'avoir plusieurs modalites avec peu d’observations*/
data filtre; set filtre;
if H14H14 in (-3, -2, -1) then H14H14 = 0;
if H14H27 in (-3, -2, -1) then H14H27 = 0; 
if REGION14 in (-3, -2, -1) then REGION14 = 0;
if H14H29 in (-3, -2, -1) then H14H29 = 0;
if P14A01 in (-3, -2, -1) then P14A01 = 0;
if P14A04 in (-3, -2, -1) then P14A04 = 0;
if P14C12 in (-3, -2, -1) then P14C12 = 0;
if P14C15 in (-3, -2, -1) then P14C15 = 0;
if I14PTOTN in (-3, -2, -1) then I14PTOTN = 0;
if EDYEAR14 in (-3, -2, -1) then EDYEAR14 = 0;
if WSTAT14 in (-3, -2, -1) then WSTAT14 = 0;
if CSPMAJ14 in (-3, -2, -1) then CSPMAJ14 = 0;
run;

data filtre; set filtre;
format age_group $ 30.;
if missing(age14) then age_group = 'Non renseigné';
else if age14 < 20 then age_group = 'Moins de 20 ans';
else if 20 <= age14 < 30 then age_group = 'Entre 20 et 30 ans';
else if 30 <= age14 < 40 then age_group = 'Entre 30 et 40 ans';
else if 40 <= age14 < 50 then age_group = 'Entre 40 et 50 ans';
else if 50 <= age14 < 60 then age_group = 'Entre 50 et 60 ans';
else if age14 >= 60 then age_group = 'Plus de 60 ans';
run;

data filtre; set filtre;
select;
when (EDYEAR14 in (-2, -1, -6)) EducationGroup = "Non classé";
when (EDYEAR14 >= 0 and EDYEAR14 <= 9) EducationGroup = "Bas";
when (EDYEAR14 >= 10 and EDYEAR14 <= 12) EducationGroup = "Moyen";
when (EDYEAR14 >= 13 and EDYEAR14 <= 17) EducationGroup = "Élevé";
when (EDYEAR14 >= 18) EducationGroup = "Très élevé";
otherwise EducationGroup = "Non renseigné";
end;

Format IncomeClass $30.;
if I14PTOTN >= 0 and I14PTOTN < 40000 then IncomeClass = "Salaire bas";
else if I14PTOTN < 80000 then IncomeClass = "Salaire moyen";
else if I14PTOTN < 150000 then IncomeClass = "Salaire élevé";
else if I14PTOTN >= 150000 then IncomeClass = "Salaire très élevé";
run;

/* Présentation de notre variable dépendante */

proc freq data = evq1;
format P14C01 sante.;
table P14C01;
run;


/* Histogramme pour toutes nos variables */


proc sgplot data=filtre;
format P14C01 sante.;
vbar age14 / datalabel group=P14C01;
xaxis values=(18 to 60 by 2); 
title "Répartition des participants par âge (18-60 ans)";
run;

proc sgplot data=filtre;
format P14C01 sante.;
vbar age_group / datalabel group=P14C01; 
title "Répartition des participants par tranche d'âge";
run;


proc sgplot data=filtre;
format sex14 sexe. P14C01 sante.;
vbar sex14 / datalabel group=P14C01;
title "Répartition des participants par sexe et état de santé";
run;


proc sgplot data=filtre;
format region14 region. P14C01 sante.;
vbar region14 / datalabel group=P14C01;
title "Répartition des participants par région d’habitation et état de santé";
run;


proc sgplot data=filtre;
format H14H14 logement. P14C01 sante.;
vbar H14H14 / datalabel group=P14C01;
title "Répartition des participants par état du logement et état de santé";
run;

proc sgplot data=filtre;
histogram P14C15 / binwidth=1;
xaxis label="Nombre de consultations chez le médecin (P14C15)" max=50;
yaxis label="Fréquence";
title "Distribution du Nombre de Consultations Médicales (P14C15)";
run;

proc sgplot data=filtre;
vbar P14C12 / datalabel;
xaxis label="Consultations chez le médecin (P14C12)";
yaxis label="Fréquence";
title "Répartition des Consultations Médicales (P14C12)";
run;

proc sgplot data=filtre;
vbar P14A01 / datalabel;
xaxis label="Pratique d'une Activité Physique (P14A01)";
yaxis label="Fréquence";
title "Répartition de la Pratique d'Activités Physiques (P14A01)";
run;

proc sgplot data=filtre;
vbar P14A04 / datalabel;
xaxis label="Nombre de Jours d'Activité Physique par Semaine (P14A04)";
yaxis label="Fréquence";
title "Répartition du Nombre de Jours d'Activité Physique (P14A04)";
run;

proc sgplot data=filtre (where=(WSTAT14 ne . and P14C01 ne .));
vbar WSTAT14 / group=P14C01 groupdisplay=cluster datalabel;
title "Visualisation de la relation entre le statut professionnel et l'état de santé";
run;

proc sgplot data=filtre(where=(CSPMAJ14 ne . and P14C01 ne .));
format P14C01 sante.;
vbar CSPMAJ14 / group=P14C01 groupdisplay=cluster datalabel;
title "Visualisation de la relation entre les catégories socio-professionnelles et l'état de santé";
run;

proc sgplot data=filtre(where=(IncomeClass ne "" and P14C01 ne .));
format P14C01 sante.;
vbar IncomeClass / group=P14C01 groupdisplay=cluster datalabel;
title "Visualisation de la relation entre les classes de revenus et l'état de santé";
run;

proc sgplot data=filtre(where=(EducationGroup ne "" and P14C01 ne .));
vbar EducationGroup / group=P14C01 groupdisplay=cluster datalabel;
title "Visualisation de la relation entre le niveau d'éducation et l'état de santé";
run;

proc sgplot data=filtre;
vbar P14C12 / group=P14C01 datalabel;
title "Relation entre l'État de Santé (P14C01) et les Consultations Médicales (P14C12)";
keylegend / title="État de Santé (P14C01)" position=right;
run;


proc freq data = filtre;
table H14H14;
table H14H27;
table region14;
table sex14;
table H14H27;
table P14A01;
table P14A04;
table P14A04;
table WSTAT14;
table CSPMAJ14; 
table EducationGroup;
table IncomeClass;
table P14C01;
run;

/* Entre les variables explicatives et la variable dependante*/

proc freq data = filtre;
table P14C01 * age_group /chisq nocol norow;
table P14C01 * region14 /chisq nocol norow;
table P14C01 * sex14 /chisq nocol norow;
table P14C01 * H14H14 /chisq nocol norow;
table P14C01 * H14H27 /chisq nocol norow;
table P14C01 * P14A01 / chisq nocol norow;
table P14C01 * P14A04 / chisq nocol norow;
table P14C01 * P14C12 / chisq nocol norow;
table P14C01 * P14C15 / chisq nocol norow;
tables P14C01 * WSTAT14/ chisq nocol norow;
tables P14C01 * IncomeClass/ chisq nocol norow;
tables P14C01 * EducationGroup/ chisq;
tables P14C01 * CSPMAJ14/ chisq;
run;
/* Toutes nos ont un lien significatif avec notre variables dependante (khi-deux élevé et p_value < 5%) */


/* Lien entre les variables explicatives */
proc freq data = filtre;
format H14H14 logement. sex14 sexe. region14 region.;
table (age_group region14 sex14 H14H14 H14H27 P14A01 P14A04 P14C12 P14C15 WSTAT14 IncomeClass EducationGroup CSPMAJ14)*(age_group region14 sex14 H14H14 H14H27 P14A01 P14A04 P14C12 P14C15 WSTAT14 IncomeClass EducationGroup CSPMAJ14) /chisq nocol norow;
run;

/* Nos variables ne sont corrélé entre elles, par conséquent on n'en supprime aucune (il n'y pas de redondance d'information)*/


/**** Modélisation ****/
/* Modele logit */
proc logistic data = filtre descending;
class  SEX14(ref='1') REGION14(ref='2') H14H14(ref='2') H14H27(ref='2') P14A01(ref='1') P14C12(ref='1') WSTAT14(ref='1') CSPMAJ14(ref='5') / param=reference;
model P14C01(ref='2') = AGE14 SEX14 REGION14 H14H14 H14H27 P14A01 P14A04 P14C12 P14C15 I14PTOTN EDYEAR14 WSTAT14 CSPMAJ14 / link=logit rsquare;
effectplot fit (x=AGE14 plotby = P14A01) / NOOBS NOLIMITS;
run;

/* Modèle MPL */
proc genmod data = filtre descending;
class  SEX14(ref='1') REGION14(ref='2') H14H14(ref='2') H14H27(ref='2') P14A01(ref='1') P14C12(ref='1') WSTAT14(ref='1') CSPMAJ14(ref='5') / param=reference;
model P14C01(ref='2') = AGE14 SEX14 REGION14 H14H14 H14H27 P14A01 P14A04 P14C12 P14C15 I14PTOTN EDYEAR14 WSTAT14 CSPMAJ14;
effectplot fit (x=AGE14 plotby = P14A01) / NOOBS NOLIMITS;
run;

/* Modele probit */
proc logistic data = filtre descending;
class  SEX14(ref='1') REGION14(ref='2') H14H14(ref='2') H14H27(ref='2') P14A01(ref='1') P14C12(ref='1') WSTAT14(ref='1') CSPMAJ14(ref='5') / param=reference;
model P14C01(ref='2') = AGE14 SEX14 REGION14 H14H14 H14H27 P14A01 P14A04 P14C12 P14C15 I14PTOTN EDYEAR14 WSTAT14 CSPMAJ14 / link=probit rsquare;
effectplot fit (x=AGE14 plotby = P14A01) / NOOBS NOLIMITS;
run;































