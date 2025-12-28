# Task 1: Large File Management & Automation

Comprehensive automation solution for detecting, managing, and cleaning up large files in Git repositories, with scheduled execution via CRON and Jenkins pipeline integration.

---

## 📋 Overview

This task provides a complete suite of tools for handling large files in Git repositories:

1. **File Generation** - Create test files of various sizes
2. **Detection** - Find and report files larger than threshold
3. **Git Management** - Commit/remove large files with proper cleanup
4. **Automated Cleanup** - CRON-based periodic execution
5. **CI/CD Integration** - Jenkins pipeline for automated scheduling

### Problem Solved

Git repositories struggle with large files because:
- Large files slow down cloning and pushing
- Storage costs increase significantly
- Team productivity decreases with slow operations

This solution automates detection and cleanup while maintaining repository integrity.

---

## 📁 Files Included

### Shell Scripts

#### 1. `01-generate-files.sh` - Test File Generation
Creates test files of various sizes for demonstration and testing.

**Usage:**
```bash
bash 01-generate-files.sh
```

**What it does:**
- Creates `test_files/` folder
- Generates files with specific sizes:
  - 10 files × 50MB each
  - 20 files × 100MB each
  - 30 files × 500MB each
  - 5 files × 1GB each
  - 3 files × 5GB each
  - 1 file × 10GB
- Logs all operations to `file_generation.log`

**Output:**
```
test_files/
├── file_50M_1.bin ... file_50M_10.bin
├── file_100M_1.bin ... file_100M_20.bin
├── file_500M_1.bin ... file_500M_30.bin
├── file_1G_1.bin ... file_1G_5.bin
├── file_5G_1.bin ... file_5G_3.bin
└── file_10G_1.bin
```

---

#### 2. `02-find-large-files.sh` - Large File Detection
Finds all files larger than 50MB and generates a sorted report.

**Usage:**
```bash
bash 02-find-large-files.sh [path]
# or
bash 02-find-large-files.sh ./test_files
```

**Output:**
- Console report with file sizes and paths
- `large_files_report.txt` with detailed summary
- Files sorted by size in **descending order**

**Sample Output:**
```
Files larger than 50MB (sorted by size, descending):
10.0G   ./test_files/file_10G_1.bin
5.0G    ./test_files/file_5G_1.bin
5.0G    ./test_files/file_5G_2.bin
1.0G    ./test_files/file_1G_1.bin
...
```

---

#### 3. `03-commit-large-file.sh` - Git Large File Management
Commits large files to Git repository and prepares for cleanup.

**Usage:**
```bash
bash 03-commit-large-file.sh
```

**What it does:**
- Stages large files for commit
- Creates commit with timestamp
- Generates list of files to clean
- Logs all operations

**Note:** This is typically followed by cleanup with BFG or Git Filter Branch.

---

#### 4. `04-bfg-cleanup.sh` - BFG Repo Cleaner
Removes committed large files from repository history using bfg-repo-cleaner.

**Prerequisites:**
```bash
# Install bfg-repo-cleaner
brew install bfg          # macOS
apt-get install bfg       # Ubuntu/Debian
# or download from: https://rtyley.github.io/bfg-repo-cleaner/
```

**Usage:**
```bash
bash 04-bfg-cleanup.sh
```

**What it does:**
1. Creates backup of repository
2. Removes large files from history
3. Cleans repository of dangling objects
4. Verifies cleanup success
5. Logs results

**Important Notes:**
- Creates `backup/` directory before cleanup
- Removes files matching patterns (*.bin, *.iso, *.zip)
- Requires forced push after cleanup
- Use with caution on shared repositories

---

#### 5. `05-cron-cleanup-job.sh` - Scheduled Automation
CRON-based script for periodic large file detection and cleanup.

**Setup CRON Job:**
```bash
# Edit crontab
crontab -e

# Add this line to run daily at 2 AM
0 2 * * * /path/to/task1-shell/05-cron-cleanup-job.sh
```

**Configuration Variables:**
```bash
LARGE_FILE_THRESHOLD="50M"   # Trigger cleanup if files exceed this
CLEAN_FILE_THRESHOLD="50M"   # Commit files smaller than this
REPO_PATH="."                # Repository path
LOG_FILE="cron_cleanup.log"  # Log file location
```

**What it does:**
1. **Detect** - Finds files larger than threshold
2. **Report** - Logs findings to `cron_cleanup.log`
3. **Cleanup** - Moves large files to `large_files_to_clean/`
4. **Commit Small Files** - Commits files under threshold
5. **Track Status** - Maintains detailed logs

**Log Output:**
```
[2025-12-28 02:00:00] Detecting files larger than 50M...
[2025-12-28 02:00:05] Found large files:
[2025-12-28 02:00:05]   - ./test_files/file_10G_1.bin (10G)
[2025-12-28 02:01:30] Cleanup completed successfully
```

---

### Jenkins Pipeline Configuration

#### `06-jenkins-job-config.groovy` - Automated Pipeline
Complete Jenkins pipeline for automated large file management.

**Setup Instructions:**

1. **Create New Pipeline Job in Jenkins:**
   - Jenkins Dashboard → New Item → Pipeline
   - Name: `Large-File-Cleanup-Pipeline`
   - Select: Pipeline

2. **Configure Pipeline:**
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: Your repository
   - Script Path: `task1-shell/06-jenkins-job-config.groovy`

3. **Or paste Groovy content directly:**
   - Definition: Pipeline script
   - Copy content from `06-jenkins-job-config.groovy`

**Pipeline Stages:**

```
Stage 1: Checkout
  ↓
Stage 2: Detect Large Files
  ↓
Stage 3: Cleanup Large Files (if found)
  ↓
Stage 4: Commit Small Files
  ↓
Stage 5: Publish Report
```

**Environment Variables:**
```groovy
LARGE_FILE_THRESHOLD = '50M'    # Detection threshold
CLEAN_FILE_THRESHOLD = '50M'    # Commit threshold
LOG_FILE = 'jenkins_cleanup.log'
```

**Triggers:**
- **Scheduled:** Daily at 2 AM (CRON: `0 2 * * *`)
- **Manual:** Click "Build Now" to run manually
- **SCM Poll:** Triggered on repository changes

**Build Configuration:**
```groovy
options {
    buildDiscarder(logRotator(numToKeepStr: '10'))  // Keep 10 builds
    timeout(time: 1, unit: 'HOURS')                  // 1-hour timeout
}
```

**Success Criteria:**
- All stages pass ✅
- No files larger than threshold found ✅
- Small files committed successfully ✅
- Detailed logs published ✅

**Sample Jenkins Output:**
```
[Pipeline] Detect Large Files
No large files found - repository is clean ✅

[Pipeline] Commit Small Files
Committing files smaller than 50M...
Committed 15 files (total 200MB) ✅

[Pipeline] Publish Report
Report: large_files_report.txt ✅

[Pipeline] End of Pipeline
✅ SUCCESS
```

---

## 🚀 Quick Start

### 1. Generate Test Files
```bash
cd task1-shell
bash 01-generate-files.sh
```

### 2. Find Large Files
```bash
bash 02-find-large-files.sh
cat large_files_report.txt
```

### 3. Setup CRON Job (Automated)
```bash
# Edit crontab
crontab -e

# Add this line:
0 2 * * * /path/to/task1-shell/05-cron-cleanup-job.sh
```

### 4. Setup Jenkins Pipeline (Automated)
```bash
# In Jenkins:
1. Create new Pipeline job
2. Set SCM to your repository
3. Point to task1-shell/06-jenkins-job-config.groovy
4. Save and run
```

---

## 📊 Workflow Diagram

```
┌─────────────────────────────────────────────────┐
│        Large File Management Workflow           │
└─────────────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
    Generate         Detect           Cleanup
    Files           Large Files      & Commit
    (01)            (02)             (03-05)
         │               │               │
         └───────────────┼───────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
    Manual           CRON              Jenkins
    Execution        Schedule          Pipeline
    (Run any         (2AM Daily)       (Automated)
     time)           (05)              (06)
```

---

## 🔧 Configuration Guide

### File Size Thresholds

Edit the threshold in each script:

**`02-find-large-files.sh`:**
```bash
find "$FOLDER_NAME" -type f -size +50M  # Change 50M to desired size
```

**`05-cron-cleanup-job.sh`:**
```bash
LARGE_FILE_THRESHOLD="50M"   # Change threshold here
CLEAN_FILE_THRESHOLD="50M"
```

**`06-jenkins-job-config.groovy`:**
```groovy
environment {
    LARGE_FILE_THRESHOLD = '50M'    // Change threshold here
    CLEAN_FILE_THRESHOLD = '50M'
}
```

### CRON Schedule

Edit crontab with different schedules:

```bash
# Every day at 2 AM
0 2 * * *

# Every 6 hours
0 */6 * * *

# Every Monday at 3 AM
0 3 * * 1

# Every hour
0 * * * *

# Every 30 minutes
*/30 * * * *
```

---

## 📈 Monitoring & Reporting

### Log Files Generated

| Script | Log File | Purpose |
|--------|----------|---------|
| `01-generate-files.sh` | `file_generation.log` | Track file creation |
| `02-find-large-files.sh` | `large_files_report.txt` | Report large files |
| `05-cron-cleanup-job.sh` | `cron_cleanup.log` | CRON execution history |
| `06-jenkins-job-config.groovy` | Jenkins Build Logs | Pipeline execution details |

### View Logs

```bash
# File generation log
cat file_generation.log

# Large files report
cat large_files_report.txt

# CRON execution log
tail -f cron_cleanup.log

# Jenkins logs
# View in Jenkins UI: Job → Build → Console Output
```

---

## ⚠️ Important Warnings

### Before Using BFG Cleaner

1. **Create Backup:**
   ```bash
   git clone --mirror ./eizen-project ./eizen-project.bak
   ```

2. **Verify Files to Remove:**
   - Review `large_files.txt`
   - Ensure no important data will be lost

3. **Notify Team:**
   - Inform team members before cleanup
   - Requires force push
   - All team members need to re-clone

4. **Test First:**
   - Test on a branch first
   - Backup repository before main cleanup

### CRON Considerations

- Ensure scripts have execute permissions: `chmod +x *.sh`
- Full paths required in crontab entries
- Test manually before adding to crontab
- Monitor logs regularly for errors

### Jenkins Security

- Restrict pipeline access to authorized users
- Validate all file patterns before cleanup
- Monitor pipeline executions
- Keep build history for audit trail

---

## 🔐 Best Practices

1. **Always Backup:**
   ```bash
   git clone --mirror your-repo your-repo.backup
   ```

2. **Test Changes:**
   - Run scripts on test repository first
   - Verify output before executing cleanup

3. **Monitor Execution:**
   - Check logs after each run
   - Set up alerts for failures

4. **Version Control:**
   - Commit all scripts to repository
   - Track changes to thresholds

5. **Documentation:**
   - Keep records of cleanup operations
   - Document threshold decisions

---

## 🛠️ Troubleshooting

### Issue: "Permission Denied" on Scripts

**Solution:**
```bash
chmod +x *.sh
```

### Issue: CRON Job Not Running

**Check:**
```bash
# Verify crontab entry
crontab -l

# Check CRON service
sudo systemctl status cron

# Check system logs
sudo tail -f /var/log/syslog
```

### Issue: BFG Not Found

**Install:**
```bash
# macOS
brew install bfg

# Ubuntu/Debian
apt-get install bfg

# Or download: https://rtyley.github.io/bfg-repo-cleaner/
```

### Issue: Large Files Still in History

**Solution:**
```bash
# Force push changes
git push --force --all

# Verify with Git Verify
git verify-pack -v .git/objects/pack/*.idx
```

---

## 📚 References

- [BFG Repo Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [Git LFS](https://git-lfs.github.com/)
- [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
- [CRON Scheduling](https://crontab.guru/)
- [Git Filter Branch](https://git-scm.com/docs/git-filter-branch)

---

## 📝 Next Steps

1. ✅ **Generate** test files using `01-generate-files.sh`
2. ✅ **Detect** large files using `02-find-large-files.sh`
3. ✅ **Review** results in `large_files_report.txt`
4. ✅ **Setup** CRON job or Jenkins pipeline
5. ✅ **Monitor** logs for successful execution
6. ✅ **Maintain** by regularly checking for large files

---

## 💡 Key Takeaways

- **Automated:** CRON and Jenkins provide scheduling
- **Safe:** Scripts create backups before cleanup
- **Logged:** All operations tracked for audit
- **Scalable:** Works with repositories of any size
- **Maintainable:** Clear scripts and documentation

---

**Status:** ✅ Complete and Production-Ready  
**Last Updated:** December 28, 2025
