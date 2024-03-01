# vim: ts=2 sw=2 noet

# The Rocker project makes container images for R.
# We'll be bringing in a specific Shiny version, so we can't use their Shiny
# container images.  Instead, we'll use their reproducable images.
# NOTE: This is where the R version is set!
FROM rocker/r-ver:4.3.2

# Install any Ubuntu packages that we need for our R packages.
RUN apt-get update && \
	apt-get install -y libodbc2 && \
	apt-get clean && rm -rf /tmp/*

# Copy all of the files into the container's scripts directory, and set that to
# be the working directory (the PWD) for all the R commands we run.
COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts

# Install renv, so that we can import the environment.
RUN R -q -e 'install.packages("renv")' && rm -rf /tmp/*

# Restore the environment from the lock file.
# NOTE: If you change the lock file, be sure to update the Ubuntu package list
# appropriately!
RUN R -q -e 'renv::restore()' && \
	rm -rf /tmp/*

# Declare the environment variables we want, and set some default values.
# NOTE: It's understood that these defaults won't work in production.
ENV SERVER 127.0.0.1
ENV DB noDB
ENV DB_USERNAME noUsername
ENV DB_PW noPassword

# When the container is run without an explicit command, this is what we do:
# Start our Shiny app!  Listen on port 3838, and expose that to the outside.
EXPOSE 3838
CMD ["R", "-q", "-e", "shiny::runApp('/usr/local/src/myscripts', host='0.0.0.0', port=3838)"]
