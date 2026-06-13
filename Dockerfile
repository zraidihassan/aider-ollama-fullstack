# Agent de codage IA local pour stack moderne Spring Boot + Angular.
# Image autonome : JDK 21 + Maven + Node/Angular CLI + Aider, le tout
# piloté par un LLM local servi via Ollama (sur l'hôte).
FROM eclipse-temurin:21-jdk-jammy

LABEL org.opencontainers.image.title="aider-ollama-fullstack"
LABEL org.opencontainers.image.description="Agent de codage IA local (Aider + Ollama) pour Spring Boot 3 / Java 21 + Angular"
LABEL org.opencontainers.image.licenses="MIT"
LABEL aider.version="0.86.2"

ENV MAVEN_VERSION=3.9.9
ENV NODE_MAJOR=20
ENV PATH="/opt/apache-maven-${MAVEN_VERSION}/bin:${PATH}"
# Chrome headless pour les tests Angular/Karma (ng test --browsers=ChromeHeadless)
ENV CHROME_BIN=/usr/bin/chromium

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash curl git vim nano tree htop ca-certificates dos2unix gnupg \
        python3 python3-pip python3-venv \
        chromium \
    && rm -rf /var/lib/apt/lists/*

# Node.js (NodeSource) + Angular CLI pour builder/tester le front
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g @angular/cli \
    && rm -rf /var/lib/apt/lists/*

# Maven (ajouté au PATH via ENV ci-dessus)
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt

# Aider (embarque litellm) — installé dans un venv isolé
RUN python3 -m venv /opt/aider \
    && /opt/aider/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/aider/bin/pip install --no-cache-dir aider-chat==0.86.2
ENV PATH="/opt/aider/bin:${PATH}"

RUN git config --global user.email "ai-agent@local" \
    && git config --global user.name "AI Coding Agent" \
    && git config --global --add safe.directory /project

# Les scripts deviennent des commandes du PATH.
# dos2unix corrige les CRLF (Windows) qui casseraient le shebang.
COPY scripts/ /usr/local/bin/
RUN dos2unix /usr/local/bin/*.sh && chmod +x /usr/local/bin/*.sh

WORKDIR /project
VOLUME ["/project"]

CMD ["bash", "-c", "echo \"Aider 0.86.2 + JDK 21 + Maven ${MAVEN_VERSION} + Node ${NODE_MAJOR} prêt\" && tail -f /dev/null"]
