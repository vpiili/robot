FROM python:3.7-alpine3.9

RUN apk update
RUN apk add --no-cache \
   udev \
   chromium \
   chromium-chromedriver \
   xvfb


RUN pip install --no-cache-dir \
 robotframework \
 robotframework-selenium2library \
 selenium \
 robotframework-react

# Chrome requires docker to have cap_add: SYS_ADMIN if sandbox is on.
# Disabling sandbox and gpu as default.
# Copied this from internet - im not really that smart :)
RUN sed -i "s/self._arguments\ =\ \[\]/self._arguments\ =\ \['--no-sandbox',\ '--disable-gpu'\]/" $(python -c "import site; print(site.getsitepackages()[0])")/selenium/webdriver/chrome/options.py;

COPY entrypoint.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

ENV SCREEN_WIDTH 1920
ENV SCREEN_HEIGHT 1080
ENV SCREEN_DEPTH 24

ENTRYPOINT [ "/opt/bin/entry_point.sh" ]
