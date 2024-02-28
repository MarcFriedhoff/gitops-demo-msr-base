FROM default-route-openshift-image-registry.apps-crc.testing/build/wpx AS wpx

FROM default-route-openshift-image-registry.apps-crc.testing/build/webmethods-microservicesruntime:10.15

COPY --from=wpx /root/wpx /opt/softwareag/wpx

# make msr openshift compatible

RUN chgrp -R 0 /opt/softwareag && \
    chmod -R g=u /opt/softwareag
