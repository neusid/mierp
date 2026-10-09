import re

def fix():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The block we are looking for is:
    #                                 ],
    #                               ),
    #                             ),
    #                         ],

    target = """                                        onChanged: (val) {
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

    replacement = """                                        onChanged: (val) {
                                          if (val != null) {
                                            context.read<SummaryBloc>().add(SummaryFilterChanged(val));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),"""

    if target in content:
        content = content.replace(target, replacement)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Fixed!")
    else:
        print("Not found")

fix()
