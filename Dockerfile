# vim: ts=2 sw=2 noet

# The Rocker project makes container images for R.
# We want their container image that includes Shiny.
# NOTE: This is where the R version is set!
FROM rocker/shiny:4.3.2

# Install any Ubuntu packages that we need for our R packages.
RUN apt-get update && \
	apt-get install -y libodbc2 && \
	apt-get clean && rm -rf /tmp/*

# Copy all of the files into the container's scripts directory, and set that to
# be the working directory (the PWD) for all the R commands we run.
COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts

# Install what we need in order to install packages:
# * remotes lets us install specific versions of packages
# * readr parses CSV files
RUN R -q -e 'install.packages("remotes")' && R -q -e 'install.packages("readr")' && rm -rf /tmp/*
