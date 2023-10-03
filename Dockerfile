
FROM ubuntu:22.04



ARG TARGETPLATFORM



ENV USER="ou"
ENV UID="1000"
ENV GID="100"
ENV MODULE_CODE="MST374"
ENV MODULE_PRESENTATION="23J"
ENV HOME="/home/$USER/$MODULE_CODE-$MODULE_PRESENTATION"
ENV SHELL="/bin/bash"
ENV CARGO_HOME="/opt/cargo"
ENV PATH="$PATH:/opt/cargo/bin"



USER root


RUN mkdir /home/$USER && \
    useradd -u $UID -g $GID -d $HOME -m -s /bin/bash $USER


RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tini



  
    

  



  



  
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential gcc git gnutls-dev imagemagick libcurl3-gnutls libcurl3-gnutls libcurl3-gnutls-dev pandoc pandoc-citeproc pandoc-data python3-pip sudo texlive-fonts-recommended texlive-latex-extra texlive-pictures texlive-plain-generic texlive-xetex unzip wget zip
  



  
RUN pip install --no-cache-dir --extra-index-url=https://www.piwheels.org/simple "jupyter_server<4.0.0" "jupyterhub>=3.0.0,<4" "nbclassic>=0.4.8,<1.0.0" "ou-container-content>=1.2.0" "pycurl" "pycurl" 
  



  
RUN mkdir -p /etc/module-content/data
COPY ou-builder-build/content/content_config.yaml /etc/module-content/config.yaml
    
      
        
          
COPY ./requirements-cnb.txt /tmp/requirements-cnb.txt
          
        
      
        
          
COPY ./requirements-jlv4.txt /tmp/requirements-jlv4.txt
          
        
      
        
          
COPY ./requirements.txt /tmp/requirements.txt
          
        
      
        
          
COPY ./content /etc/module-content/data/./content
          
        
      
        
          
COPY ./.jupyter /etc/module-content/data/~/.jupyter
          
        
      
        
          
COPY ou-builder-build/packs/nbclassic/custom /etc/module-content/data/.jupyter/custom
          
        
      
        
          
COPY ou-builder-build/services/services.sudoers /etc/sudoers.d/99-services
          
        
      
        
          
COPY ou-builder-build/ou_core_config.json /usr/local/etc/jupyter/jupyter_server_config.json
          
        
      
        
          
COPY ou-builder-build/startup/start.sh /usr/bin/start.sh
          
        
      
        
          
COPY ou-builder-build/startup/home-dir.sudoers /etc/sudoers.d/99-home-dir
          
        
      
    
  



  
    
      
RUN python3 -m pip install --upgrade pip && \
    pip install --upgrade git+https://github.com/ouseful-PR/nbval.git@table-test && \
    pip install pytest-html
      
    
      
RUN pip install -r /tmp/requirements-cnb.txt && \
    pip install -r /tmp/requirements-jlv4.txt && \
    pip install -r /tmp/requirements.txt
      
    
      
RUN pip install --upgrade --no-deps git+https://github.com/mwaskom/seaborn.git && \
    pip install git+https://github.com/innovationOUtside/ipython_magic_tikz.git
      
    
      
RUN jupyter nbclassic-serverextension enable --py --system nbzip && \
    jupyter nbclassic-extension install --py --system nbzip && \
    jupyter nbclassic-extension enable --py --system nbzip
      
    
      
RUN jupyter nbclassic-extension install --py --system jupyter_nbextensions_configurator && \
    jupyter nbclassic-extension enable --py --system jupyter_nbextensions_configurator && \
    jupyter nbclassic-serverextension enable --py --system jupyter_nbextensions_configurator && \
    jupyter nbclassic-extension install --py --system jupyter_contrib_nbextensions && \
    jupyter nbclassic-extension enable --system spellchecker/main && \
    jupyter nbclassic-extension enable --system collapsible_headings/main && \
    jupyter nbclassic-extension enable --system skip-traceback/main && \
    jupyter nbclassic-extension enable --system codefolding/main && \
    jupyter nbclassic-extension enable --system highlighter/highlighter
      
    
      
RUN git clone https://github.com/uclixnjupyternbaccessibility/accessibility_toolbar.git && \
    jupyter nbclassic-extension install accessibility_toolbar && \
    rm -rf accessibility_toolbar
      
    
      
RUN VERSION="${MODULE_CODE}_${MODULE_PRESENTATION}_0.01" && \
    DATE=`date +%Y-%m-%d/%H:%M.%S` && \
    mkdir -p /etc/ouseful && \
    echo "Version: ${VERSION} - build time: ${DATE}." > /etc/ouseful/.container_version && \
    chmod ugo+r /etc/ouseful/.container_version
      
    
      
RUN pip uninstall -y notebook && \
    jupyter server extension enable --system nbclassic
      
    
      
RUN chmod a+x /usr/bin/start.sh && \
    chmod 0660 /etc/sudoers.d/99-home-dir
      
    
      
RUN ou-container-content prepare
      
    
  





  
    
COPY ou-builder-build/packs/nbclassic/brand-assets/ /etc/brand-assets/
RUN python3 -c 'import nbclassic; from distutils.dir_util import copy_tree; import os; target=os.path.join(nbclassic.__path__[0]); copy_tree("/etc/brand-assets", target)' \
  && python3 -c 'import jupyter_server; from distutils.dir_util import copy_tree; import os; target=os.path.join(jupyter_server.__path__[0]); copy_tree("/etc/brand-assets", target)'
    
  



RUN chown -R $UID:$GID $HOME /etc/module-content


USER $USER


WORKDIR $HOME
ENTRYPOINT ["tini", "-g", "--"]



EXPOSE 8888



CMD ["start.sh"]
