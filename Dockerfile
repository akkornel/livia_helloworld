# vim: ts=2 sw=2 noet

# The Rocker project makes container images for R.
# We'll be bringing in a specific Shiny version, so we can't use their Shiny
# container images.  Instead, we'll use their reproducable images.
# NOTE: This is where the R version is set!
FROM rocker/r-ver:4.3.2
LABEL org.opencontainers.image.base.name="rocker/r-ver:4.3.2"

# Set some image metadata!
# NOTE: Some of the OCI labels are set automatically by the GitHub Actions workflow.
# NOTE: org.opencontainers.image.base.name is set above this block, as a subtle
#       reminder that, when you change the source image, you also need to
#       update the label!
LABEL org.opencontainers.image.description="A simple app to test if this all works!"
LABEL org.opencontainers.image.documentation="TBD"
LABEL org.opencontainers.image.licenses="UNLICENSED"
#LABEL org.opencontainers.image.source gets set to the repo's URL
#LABEL org.opencontainers.image.title gets set to the repo's name
#LABEL org.opencontainers.image.url gets set to the repo's URL
#LABEL org.opencontainers.image.version gets set to the repo's branch/tag name

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
# NOTE: Renv caches downloaded packages, so we have to clean them up at the end.
#       The `use.cache` setting applies to installed packages, not sources.
# TODO: See if we can save the package downloads somewhere
RUN R -q -e 'renv::settings$use.cache(FALSE)' -e 'renv::restore()' && \
	rm -rf /tmp/* /root/.cache/R/renv/source/repository/*

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
