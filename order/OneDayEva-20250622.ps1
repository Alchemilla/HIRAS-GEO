# 配置参数
$exePath = "C:\Users\GZC\OneDrive\2-CProject\25-HIRAS\bin\Release\GEO_HIRAS.exe"  # EXE path
$fixedPath1 = "E:\1-FY3F\Paper\caliparam_CH22_2025.06.22.txt"  # calibration parameters
$basePath2 = "E:\1-FY3F\POSATT\2025"  # orbit and attitude
$basePath3 = "E:\1-FY3F\OBC\20250622"  # HIRAS OBC HDF FILE PATH
$basePath4 = "E:\1-FY3F\L1\20250622"  # HIRAS L1 HDF FILE PATH
$basePath5 = "E:\1-FY3F\MERSI_L1\20250622"  # MERSI L1 HDF FILE PATH
$basePath6 = "E:\1-FY3F\MERSI_L1\20250622GEO"  # MERSI GEO HDF FILE PATH
$fixedPath7 = "E:\1-FY3F\SRF\FY3F_MERSI_SRF_CH22_Pub.txt"  # SRF file path
$outputPath = "E:\1-FY3F\Paper\20250622\CH22"  # output path
$ordertype = "EVA"  # geolocation error evaluation, EVA:after correction, YW:before correction
$satellite = "FY3F"  # Satellite ID
$channel = "22"  #  MERSI channel 

$timePattern = "\d{8}_\d{4}"  

$allTimeStamps = @()
$allTimeStamps += Get-ChildItem -Path $basePath3 -Filter "*.HDF" | ForEach-Object { 
    if ($_.Name -match $timePattern) { $matches[0] }
}
$allTimeStamps += Get-ChildItem -Path $basePath4 -Filter "*.HDF" | ForEach-Object { 
    if ($_.Name -match $timePattern) { $matches[0] }
}
$allTimeStamps += Get-ChildItem -Path $basePath5 -Filter "*.HDF" | ForEach-Object { 
    if ($_.Name -match $timePattern) { $matches[0] }
}
$allTimeStamps += Get-ChildItem -Path $basePath6 -Filter "*.HDF" | ForEach-Object { 
    if ($_.Name -match $timePattern) { $matches[0] }
}

# 去重并排序
$allTimeStamps = $allTimeStamps | Sort-Object -Unique

if ($allTimeStamps.Count -eq 0) {
    Write-Warning "No timestamp files found in the specified paths. Exiting."
    exit 1
}

Write-Host "Found $($allTimeStamps.Count) unique timestamps to process."

# 遍历每个时间点
foreach ($timeStamp in $allTimeStamps) {
    # 解析时间戳
    $datePart = $timeStamp.Substring(0, 8)  # 提取YYYYMMDD部分
    $timePart = $timeStamp.Substring(9, 4)  # 提取HHMM部分

	# 构建输出路径
    $outPath = Join-Path $outputPath "FY3F_HIRAS_GRAN_L1_${timeStamp}_014KM_V0_err24.txt"  # 根据实际输出文件名调整

    # 检查输出是否已存在
    if (Test-Path $outPath) {
        Write-Warning "Output already exists for $timeStamp. Skipping."
        continue
    }
	
    # 构建第2个参数的文件路径（基于日期）
    $file2 = Get-ChildItem -Path $basePath2 -Filter "*${datePart}*.HDF" | 
             Select-Object -First 1
    if (-not $file2) {
        Write-Warning "No type2 file found for date $datePart. Skipping time $timeStamp."
        continue
    }

    # 构建第3个参数的文件路径（基于完整时间戳）
    $file3 = Get-ChildItem -Path $basePath3 -Filter "*${timeStamp}*.HDF" | 
             Select-Object -First 1
    if (-not $file3) {
        Write-Warning "No type3 file found for time $timeStamp in path $basePath3. Skipping."
        continue
    }

    # 构建第4个参数的文件路径（基于完整时间戳）
    $file4 = Get-ChildItem -Path $basePath4 -Filter "*${timeStamp}*.HDF" | 
             Select-Object -First 1
    if (-not $file4) {
        Write-Warning "No type4 file found for time $timeStamp in path $basePath4. Skipping."
        continue
    }

    # 构建第5个参数的文件路径（基于完整时间戳）
    $file5 = Get-ChildItem -Path $basePath5 -Filter "*${timeStamp}*.HDF" | 
             Select-Object -First 1
    if (-not $file5) {
        Write-Warning "No type5 file found for time $timeStamp in path $basePath5. Skipping."
        continue
    }
	
	# 构建第6个参数的文件路径（基于完整时间戳）
    $file6 = Get-ChildItem -Path $basePath6 -Filter "*${timeStamp}*.HDF" | 
             Select-Object -First 1
    if (-not $file6) {
        Write-Warning "No type6 file found for time $timeStamp in path $basePath6. Skipping."
        continue
    }


    # 构建参数数组
    $arguments = @(
        $fixedPath1,
        $file2.FullName,
        $file3.FullName,
        $file4.FullName,
        $file5.FullName,
        $file6.FullName,
        $fixedPath7,
        $outputPath,
		$ordertype,		
		$satellite,
		$channel
    )

    # 显示正在处理的信息
    Write-Host "Processing time $timeStamp..."
    Write-Host "File2: $($file2.Name)"
    Write-Host "File3: $($file3.Name)"
    Write-Host "File4: $($file4.Name)"
    Write-Host "File5: $($file5.Name)"
    Write-Host "File6: $($file6.Name)"
    Write-Host "Output: $outputPath"

    # 调用EXE程序
    try {
        $process = Start-Process -FilePath $exePath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "Successfully processed $timeStamp.`n`n"
        } else {
            Write-Warning "Process failed with exit code $($process.ExitCode) for time $timeStamp."
        }
    }
    catch {
        Write-Warning "Error processing $timeStamp : $($_.Exception.Message)"
    }
}

Write-Host "Processing complete."