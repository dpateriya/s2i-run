FROM quay.io/rhn_support_dpateriy/python-36-rhel7:latest

USER root

RUN yum repolist --disablerepo=* && yum clean all

COPY rhel-7-server-rpms.repo rhel-7-server-optional-rpms.repo /etc/yum.repos.d/
RUN rpm -e gcc gcc-c++ libquadmath-devel gcc-gfortran && \
  yum update -y && yum clean all -y && yum install -y less groff-base

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
  unzip awscliv2.zip && \
  ./aws/install && \
  mkdir /opt/app-root/src/.aws
COPY aws_config /opt/app-root/src/.aws/config
RUN chown -R 1001:1001 /opt/app-root && \
          chmod -R 755 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["/usr/local/s2i/run"]
