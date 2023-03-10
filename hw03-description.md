# Homework 3: Reproducibility in Climate Studies

* **Statistics 159/259, Spring 2022**
* **Due 03/23/2023, 23:59PM PT**
* Prof. F. Pérez and GSI F. Sapienza, Department of Statistics, UC Berkeley.
* This assignment is worth a maximum of **50 points**.
* Assignment type: **group homework assignment** (Check on Piazza about group's assignments).


**Deliverable:** for this assignment, your github repository should contain:

- One notebook PER QUESTION that includes code for plots and simulations, along with your written responses and discussion. Please remember to use markdown headings for each section/subsection so the entire document is readable. All figures should be included in both the notebook and in a separape image file inside a folder `outputs`.

- Complete the contribution statement  

For the first part of the homework (15 points) we are going to reproduce the result from the lecture using the Mauna Loa CO2 data. For the second part of the homework  (30 points) we will reproduce the results from Figure 1 to 3 in 

Gentemann, Chelle L., Fewings, Melanie R. and García‐Reyes, Marisol. "[Satellite sea surface temperatures along the West Coast of the United States during the 2014–2016 northeast Pacific marine heat wave.](https://agupubs.onlinelibrary.wiley.com/doi/10.1002/2016GL071039)" _Geophysical Research Letters_ 44, no. 1 (2017): 312-319. [DOI: 10.1002/2016GL071039](https://doi.org/10.1002/2016GL071039).

We had provided you with the Matlab code used to generate such figures. This may help you as a guide for running the analysis, but is not expected that you use the Matlab code as a template for yours. 

The total grade for this homework is divided between:
- [15 Points] The Manua Loa CO2 Data. 
- [30 Points] The West Coast Heat Wave.
- [5 Points] Project Structure. See next section for mode details


At the moment of running your analyses and making plots, it may be useful to save xarray datasets as `netcdf` files and then read them in order to make just the plots. You can do this with [xarray.Dataset.to_netcdf](https://docs.xarray.dev/en/stable/generated/xarray.Dataset.to_netcdf.html).

### Project Structure

In this homework we are going to evaluate the overall workflow using git a GitHub. Be sure that you repository includes clear commit messages as you make progress on the homework; not include any other file or folder that those needed for the project. For archiving this you can include a `.gitignore` file with the files you want git to ignore. The code in each notebook must be well organized. Use different cells for different operations and functions and markdown cells to explain the analysis. Use commit messages in git as you make progress in your homework. You can also use different branches or make a fork of the main repository (and then a pull request) in order to work collaboratively in the same notebook. 

You will have to divide the notebook `hw03-climate.ipynb` into six different notebooks, one for each question. Name each one of this notebooks `climate-QXX.ipynb`, with `XX` corresponding to the number of the question (eg, `climate-Q02.ipynb`). You will have to move the code from `hw03-climate.ipynb` to each notebook in such a way that all each notebook can be executed. You will have to take a look at which imports to make and what data to read in each notebook. For the final deliverable, remove the notebook `hw03-climate.ipynb` from the repository. 


**Acknowledgment:** Large part of the contents in this homework assignment were done by [Dr. Chelle Gentemann](https://cgentemann.github.io).