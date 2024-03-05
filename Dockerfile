FROM default-route-openshift-image-registry.apps-crc.testing/build/wpx AS wpx
FROM default-route-openshift-image-registry.apps-crc.testing/build/webmethods-microservicesruntime:10.15.0.9-ubi as install
FROM ubi8/ubi:latest as base
ENV SAG_HOME /opt/softwareag

COPY --from=install --chown=0:0 ${SAG_HOME} ${SAG_HOME}
COPY --from=wpx /root/wpx ${SAG_HOME}/wpx

RUN chgrp -R 0 ${SAG_HOME} && chmod -R g=u ${SAG_HOME}

# make msr openshift compatible

FROM ubi8/ubi:latest

ENV SAG_HOME /opt/softwareag
ENV JAVA_HOME ${SAG_HOME}/jvm/jvm/
ENV JRE_HOME ${SAG_HOME}/jvm/jvm/
COPY --from=base ${SAG_HOME} ${SAG_HOME}

RUN chgrp 0 ${SAG_HOME} && chmod g=u ${SAG_HOME}

EXPOSE 5555
EXPOSE 9999
EXPOSE 5543

VOLUME [ "/opt/softwareag" ]

ENTRYPOINT ["/opt/softwareag/IntegrationServer/bin/startContainer.sh"]
