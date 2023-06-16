import streamlit as st
import sqlite3
import matplotlib.pyplot as plt
import numpy as np


st.title ('Vivino analysis')
st.markdown ('Natalia Evgrafova 16.06.2023')
st.sidebar.title('Wine market analysis')

container = st.container() 
pic = st.container()
db = sqlite3.connect('vivino_v2.db')
c = db.cursor()


with st.sidebar:
    
    if st.sidebar.button('Ten wines to increase sales'): 
        container.write('Ten wines')
        wines_ten = c.execute("""SELECT  wines.name, wines.ratings_average, wines.ratings_count, ROUND(AVG(price_euros)) AS average_price
                            FROM wines 
                            INNER JOIN vintages 
                            ON wines.id = vintages.wine_id
                            WHERE wines.ratings_count<10000 AND wines.ratings_count>1000
                            GROUP BY wine_id
                            HAVING vintages.price_euros < 460
                            ORDER BY wines.ratings_average DESC

                            LIMIT 10;""")

        container.dataframe(wines_ten, width =800, column_config = { 1:'wine_name', 2:'ratings_average', 3:'ratings_count', 4:'EUR'})



    if st.sidebar.button('Countries for marketing'):
        container.write('Countries for marketing')
        marketing_company = c.execute("""SELECT name, (users_count*1000 /population)AS users_perthousandage, users_count,population, wines_count, wineries_count
                            FROM countries
                            ORDER BY  users_perthousandage ASC, wines_count DESC
                            LIMIT 5;""")
        container.dataframe(marketing_company, width =1600, column_config = {1:'country', 2:'users/1000', 3:'users', 4:'population',5:'wines', 6:'wineries' })
        



    if  st.sidebar.button('Best winery prize'):
        container.write('Best winery')
        best_winery = c.execute("""  SELECT wineries.name AS winery_name,  AVG(ratings_average) AS avg_rating, AVG(ratings_count)  AS avg_ratings_count
                                FROM wines
                                INNER JOIN wineries
                                ON wineries.id = wines.winery_id
                                GROUP BY winery_name
                                HAVING avg_ratings_count>60000
                                ORDER BY   avg_rating DESC, avg_ratings_count DESC

                                LIMIT 10
                                        """)
        
        container.dataframe(best_winery, width =800,  column_config = { 1:'winery', 2:'rating', 3:'ratings count'})


    if st.sidebar.button ('Flavour groups'):
        flavours = c.execute("""SELECT name AS flavour, group_name AS flavour_group
                                FROM keywords_wine
                                LEFT JOIN keywords
                                ON keywords.id = keywords_wine.keyword_id
                                WHERE count>10 AND name IN ('coffee','toast','green apple', 'cream', 'citrus') AND keyword_type = 'primary'
                                GROUP BY flavour_group
                                LIMIT 10;""")

        container.dataframe(flavours, column_config = {1:'flavour', 2:'flavour group'})

   

    if st.sidebar.button('Tastes combinations'):
        tastes = c.execute(""" SELECT wine_name, COUNT(DISTINCT flavour) AS flavours_count
                                FROM wine_flavours_primary
                                GROUP BY wine_id 
                                HAVING flavours_count>4""")

        container.write('Wines with a combination of coffee,toast, green apple, cream, citrus flavours')
        
        container.dataframe(tastes, width =600, column_config = {1:'wine name', 2:'flavours number'})






    if st.sidebar.button('Grapes and wines'):
        container.write('Most popular grapes')
        grapes = c.execute(""" SELECT  COUNT(country_code) AS country_count, wines_count, grapes.name AS grape_name
                                FROM most_used_grapes_per_country AS m
                                INNER JOIN grapes
                                ON grapes.id = m.grape_id
                                GROUP BY grape_id
                                ORDER BY country_count DESC
                                LIMIT 3;""" )
       
        container.dataframe (grapes, width =700, column_config = {1:'number of countries', 2:'number of wines', 3:'grape'})

       
    if st.sidebar.button ("Best wines for popular grapes"):
        container.write('Cabernet Sauvignon, Merlot, Chardonnay')
        pic.image('Cabernet.png')
        
        pic.image('Merlot.png')
       
        pic.image('Chardonnay.png')
    




    if st.sidebar.button('Countries leadersboard'):
        container.write('Countries leadersboard')
        countries = c.execute("""SELECT c.name AS country_name, ROUND(AVG(ratings_average),4) AS countries_wine_ratings
                                FROM wines AS w
                                JOIN regions AS r 
                                ON r.id = w.region_id 
                                JOIN countries AS c 
                                ON r.country_code = c.code
                                GROUP BY c.name
                                ORDER BY countries_wine_ratings DESC
                                LIMIT 3;""")
        container.dataframe(countries, column_config = {1: 'country', 2: 'wine ratings'})






    if st.sidebar.button ('Wine recommendations'): 
        container.write ("Best Cabernet Sauvignons")

        suggestions = c.execute("""SELECT   name,  ratings_average, price_euros,ratings_count
                                FROM vintages
                                WHERE name LIKE '%Cabernet%' AND name LIKE '%Sauvignon%' AND (ratings_count>1000 OR ratings_average>4.6)
                                ORDER BY ratings_average DESC
                                LIMIT 5; """)

        container.dataframe(suggestions, width =800, column_config = { 1: 'wine', 2: 'rating', 3: 'price', 4: 'rating counts' })




   



    


        







