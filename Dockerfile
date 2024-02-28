FROM default-route-openshift-image-registry.apps-crc.testing/build/wpx AS wpx

FROM default-route-openshift-image-registry.apps-crc.testing/build/webmethods-microservicesruntime:10.15 as base

COPY --from=wpx /root/wpx /opt/softwareag/wpx

USER root

RUN chgrp -R 0 /opt/softwareag && chmod -R g=u /opt/softwareag

# make msr openshift compatible

FROM ubi8/ubi:latest

ENV SAG_HOME=/opt/softwareag
ENV JAVA_HOME=${SAG_HOME}/jvm/jvm
ENV JRE_HOME=${SAG_HOME}/jvm/jvm
COPY --from=base ${SAG_HOME} ${SAG_HOME}

USER root

RUN chgrp 0 ${SAG_HOME} && chmod g=u ${SAG_HOME}

EXPOSE 5555
EXPOSE 9999
EXPOSE 5543

ENTRYPOINT ["/opt/softwareag/IntegrationServer/bin/startContainer.sh"]
