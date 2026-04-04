#!/usr/bin/env python3
"""Convert finance data files in the data/ folder to preferred output format."""

import csv
import glob
import os
from pathlib import Path
from decimal import Decimal, InvalidOperation

SCRIPT_DIR = Path(__file__).resolve().parent
DATA_DIR = SCRIPT_DIR / "data"
OUTPUT_DIR = SCRIPT_DIR / "output"

# Column mapping per file prefix: maps source columns to preferred names
PROFILE_MAP = {
    "Chase9804": {
        "column_rename": {
            "Posting Date": "Date",
            "Description": "Name",
            "Amount": "Amount",
        },
        "lead_columns": ["Date", "Name", "Amount"],
        "date_column": "Date",
        "date_format": "%m/%d/%Y",
        "date_output_format": "%Y-%m-%d",
        "sort_ascending": True,
    },
    "Chase5863": {
        "column_rename": {
            "Transaction Date": "Date",
            "Description": "Name",
            "Amount": "Amount",
        },
        "lead_columns": ["Date", "Name", "Amount"],
        "date_column": "Date",
        "date_format": "%m/%d/%Y",
        "date_output_format": "%Y-%m-%d",
        "sort_ascending": True,
    },
    "CIT": {
        "column_rename": {
            "Date": "Date",
            "Description": "Name",
            "Debits(-)": "Debit",
            "Credits(+)": "Credit",
        },
        "lead_columns": ["Date", "Name", "Amount"],
        "date_column": "Date",
        "date_format": "%m/%d/%Y",
        "date_output_format": "%Y-%m-%d",
        "sort_ascending": True,
        "combine_amount": {
            "debit": "Debits(-)",
            "credit": "Credits(+)"
        },
    },
    "ally": {
        "column_rename": {
            "Date": "Date",
            "Description": "Name",
            "Amount": "Amount",
        },
        "lead_columns": ["Date", "Name", "Amount"],
        "date_column": "Date",
        "date_format": "%Y-%m-%d",
        "date_output_format": "%Y-%m-%d",
        "sort_ascending": True,
    },
}


def detect_profile(filename: str) -> str | None:
    """Return the profile key that matches the filename, or None."""
    for prefix in PROFILE_MAP:
        if filename.startswith(prefix):
            return prefix
    return None


def parse_money(value: str) -> Decimal:
    """Parse currency-like strings into Decimal, defaulting to 0."""
    cleaned = (value or "").strip().replace("$", "").replace(",", "")
    if not cleaned:
        return Decimal("0")
    try:
        return Decimal(cleaned)
    except InvalidOperation:
        return Decimal("0")


def convert_file(filepath: Path, profile_key: str) -> Path:
    """Read a CSV, apply the profile transformations, and write to output/."""
    profile = PROFILE_MAP[profile_key]
    rename = profile["column_rename"]
    lead = profile["lead_columns"]
    date_col = profile["date_column"]
    date_fmt = profile["date_format"]
    date_out_fmt = profile.get("date_output_format")
    ascending = profile["sort_ascending"]

    combine_amount = profile.get("combine_amount")

    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        source_columns = [
            (header or "").strip().lstrip("\ufeff")
            for header in (reader.fieldnames or [])
            if (header or "").strip()
        ]
        rows = []
        for row in reader:
            normalized = {}
            for key, value in row.items():
                if key is None:
                    # Ignore unnamed trailing fields in some exports (e.g. balance column without header).
                    continue
                clean_key = key.strip().lstrip("\ufeff")
                normalized[clean_key] = value
            rows.append(normalized)

    # Build renamed rows
    renamed_rows = []
    for row in rows:
        new_row = {}
        for src_col in source_columns:
            dest_col = rename.get(src_col, src_col)
            new_row[dest_col] = row.get(src_col, "")

        if combine_amount:
            debit_col = combine_amount["debit"]
            credit_col = combine_amount["credit"]
            debit_val = parse_money(row.get(debit_col, ""))
            credit_val = parse_money(row.get(credit_col, ""))
            # Use credit - debit so outgoing transactions become negative.
            amount = credit_val - abs(debit_val)
            new_row["Amount"] = f"{amount:.2f}"

        renamed_rows.append(new_row)

    # Sort by date
    from datetime import datetime

    def parse_date(row):
        try:
            return datetime.strptime(row[date_col].strip(), date_fmt)
        except (ValueError, KeyError):
            return datetime.min

    renamed_rows.sort(key=parse_date, reverse=not ascending)

    # Reformat dates if an output format is specified
    if date_out_fmt:
        for row in renamed_rows:
            try:
                dt = datetime.strptime(row[date_col].strip(), date_fmt)
                row[date_col] = dt.strftime(date_out_fmt)
            except (ValueError, KeyError):
                pass

    # Build final column order: lead columns first, then remaining in original order
    all_dest_cols = [rename.get(c, c) for c in source_columns]
    if combine_amount and "Amount" not in all_dest_cols:
        all_dest_cols.append("Amount")
    remaining = [c for c in all_dest_cols if c not in lead]
    output_columns = lead + remaining

    # Write output
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = OUTPUT_DIR / filepath.name
    with open(out_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=output_columns)
        writer.writeheader()
        writer.writerows(renamed_rows)

    return out_path


def main():
    csv_files = sorted(DATA_DIR.glob("*.CSV")) + sorted(DATA_DIR.glob("*.csv"))
    if not csv_files:
        print("No CSV files found in", DATA_DIR)
        return

    for filepath in csv_files:
        profile_key = detect_profile(filepath.name)
        if profile_key is None:
            print(f"SKIP  {filepath.name} (no matching profile)")
            continue
        out = convert_file(filepath, profile_key)
        print(f"OK    {filepath.name} -> {out.relative_to(SCRIPT_DIR)}")


if __name__ == "__main__":
    main()
