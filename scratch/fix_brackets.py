import re

def fix_bracket():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # I'll just find the exact dropdown block ending and add the closing brackets for Row and Container.
    
    target = """                                        onChanged: (val) {
                                          if (val != null) {
                                            context.read<SummaryBloc>().add(SummaryFilterChanged(val));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],"""

    replacement = """                                        onChanged: (val) {
                                          if (val != null) {
                                            context.read<SummaryBloc>().add(SummaryFilterChanged(val));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),"""

    if target in content:
        content = content.replace(target, replacement)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Fixed brackets!")
    else:
        print("Target not found.")

fix_bracket()
