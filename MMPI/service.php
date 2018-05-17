{\rtf1\ansi\ansicpg1251\cocoartf1561\cocoasubrtf400
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;\red251\green0\blue7;\red255\green255\blue255;\red67\green67\blue67;
\red15\green101\blue1;\red73\green17\blue135;\red34\green0\blue91;\red38\green38\blue38;\red181\green0\blue19;
\red151\green0\blue126;\red10\green86\blue216;}
{\*\expandedcolortbl;;\cssrgb\c100000\c0\c0;\cssrgb\c100000\c100000\c100000;\cssrgb\c33333\c33333\c33333;
\cssrgb\c1961\c45882\c0;\cssrgb\c36078\c14902\c60000;\cssrgb\c18039\c5098\c43137;\cssrgb\c20000\c20000\c20000;\cssrgb\c76863\c10196\c8627;
\cssrgb\c66667\c5098\c56863;\cssrgb\c0\c43529\c87843;}
\paperw11900\paperh16840\margl1440\margr1440\vieww14160\viewh11720\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs34 \cf2 \cb3 \expnd0\expndtw0\kerning0
<?php\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 // Create connection\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf6 \cb3 $con\cf7 =mysqli_connect\cf8 (\cf9 "localhost"\cf8 , \cf9 \'abu380711324_admin\'bb\cf8 ,\cf9  \'abLyamzinedu21\'bb\cf8 , \cf9 \'abu380711324_mmpi\'bb\cf8 );\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 // Check connection\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf10 \cb3 if\cf11  \cf8 (\cf7 mysqli_connect_errno\cf8 ())\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf8 \cb3 \{\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf11 \cb3 \'a0\'a0\cf10 echo\cf11  \cf9 "Failed to connect to MySQL: "\cf11  \cf8 .\cf11  \cf7 mysqli_connect_error\cf8 ();\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf8 \cb3 \}\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 // This SQL statement selects ALL from the table 'Locations'\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf6 \cb3 $sql\cf11  \cf7 =\cf11  \cf9 "SELECT * FROM Locations"\cf8 ;\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 // Check if there are results\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf10 \cb3 if\cf11  \cf8 (\cf6 $result\cf11  \cf7 =\cf11  \cf7 mysqli_query\cf8 (\cf6 $con\cf8 ,\cf11  \cf6 $sql\cf8 ))\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf8 \cb3 \{\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf11 \cb3 	\cf5 // If so, then create a results array and a temporary one\cf0 \cb1 \
\cf11 \cb3 	\cf5 // to hold the data\cf0 \cb1 \
\cf11 \cb3 	\cf6 $resultArray\cf11  \cf7 =\cf11  \cf6 array\cf8 ();\cf0 \cb1 \
\cf11 \cb3 	\cf6 $tempArray\cf11  \cf7 =\cf11  \cf6 array\cf8 ();\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf11 \cb3 	\cf5 // Loop through each row in the result set\cf0 \cb1 \
\cf11 \cb3 	\cf10 while\cf8 (\cf6 $row\cf11  \cf7 =\cf11  \cf6 $result\cf7 ->fetch_object\cf8 ())\cf0 \cb1 \
\cf11 \cb3 	\cf8 \{\cf0 \cb1 \
\cf11 \cb3 		\cf5 // Add each row into our results array\cf0 \cb1 \
\cf11 \cb3 		\cf6 $tempArray\cf11  \cf7 =\cf11  \cf6 $row\cf8 ;\cf0 \cb1 \
\cf11 \cb3 	\'a0\'a0\'a0\'a0\cf7 array_push\cf8 (\cf6 $resultArray\cf8 ,\cf11  \cf6 $tempArray\cf8 );\cf0 \cb1 \
\cf11 \cb3 	\cf8 \}\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf11 \cb3 	\cf5 // Finally, encode the array to JSON and output the results\cf0 \cb1 \
\cf11 \cb3 	\cf10 echo\cf11  \cf7 json_encode\cf8 (\cf6 $resultArray\cf8 );\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf8 \cb3 \}\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 \'a0\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf5 \cb3 // Close connections\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf7 \cb3 mysqli_close\cf8 (\cf6 $con\cf8 );\cf0 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf2 \cb3 ?>}