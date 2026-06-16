#Requires AutoHotkey v2.0
#SingleInstance Force

^!s:: {
    randomNum := Random(100000, 999999)
    project := "demo_" randomNum
    fullPath := "C:\Users\vince\JavaProjects\spring_pg\" project
    psScriptFile := "C:\Users\vince\JavaProjects\spring_pg\run_spring.ps1"

    if !DirExist("C:\Users\vince\JavaProjects")
        DirCreate("C:\Users\vince\JavaProjects")
    if !DirExist("C:\Users\vince\JavaProjects\spring_pg")
        DirCreate("C:\Users\vince\JavaProjects\spring_pg")

    script := "$env:PATH += ';C:\Users\vince\scoop\shims'`n"
    script .= "$project = '" project "'`n"
    script .= "$fullPath = '" fullPath "'`n"
    script .= "$dbPassword = 'postgres'`n"
    script .= "spring init --dependencies=web,data-jpa,postgresql --build=maven --name=`$project --package-name=com.example.`$project `"`$fullPath`"`n"
    script .= "`$env:PGPASSWORD = `$dbPassword`n"
    script .= "& 'C:\Program Files\PostgreSQL\18\pgAdmin 4\runtime\psql.exe' -U postgres -h localhost -p 5432 -c `"CREATE DATABASE `$project;`"`n"
    script .= "Set-Content `"`$fullPath\src\main\resources\application.properties`" `"spring.application.name=`$project`nserver.port=8082`nspring.datasource.url=jdbc:postgresql://localhost:5432/`$project`nspring.datasource.username=postgres`nspring.datasource.password=`$dbPassword`nspring.datasource.driver-class-name=org.postgresql.Driver`nspring.jpa.hibernate.ddl-auto=update`nspring.jpa.show-sql=true`"`n"
    script .= "& 'C:\Program Files\JetBrains\IntelliJ IDEA 2023.2.2\bin\idea64.exe' `"`$fullPath`"`n"

    if FileExist(psScriptFile)
        FileDelete(psScriptFile)
    FileAppend(script, psScriptFile)
    Run("wscript.exe `"C:\Users\vince\ahk\run_silent.vbs`"")
}
