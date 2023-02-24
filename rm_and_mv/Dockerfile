ARG winver=2022
FROM mcr.microsoft.com/windows/servercore:ltsc$winver

COPY test.cmd .
CMD ["cmd.exe", "/c", "test.cmd"]

